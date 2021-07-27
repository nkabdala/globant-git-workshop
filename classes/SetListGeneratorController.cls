public without sharing class SetListGeneratorController {

    /**
     * @description Method that creates the Set_List__c for the given Show__c and fetch trought the Song__c records to insert Set_List_Song for the Set_List__c created
     * @version 1.0
     * @since 1.0
     * @author Andrea Fernandez <andrea.f@globant.com>
     * @param showId Id of the show the set list is to be created for
     * @return Id of the Set_List__c for the show the show
     * **/
    public static Id createSetList(String showId){
        if(Show__c.sObjectType.getDescribe().isAccessible() && Song__c.sObjectType.getDescribe().isAccessible() && Set_List__c.sObjectType.getDescribe().isCreateable() && Set_List__c.sObjectType.getDescribe().isUpdateable() && Set_List_Song__c.sObjectType.getDescribe().isCreateable()){
            List<Show__c> shows = [SELECT Id, Name, Length_Hours__c, Length_Minutes__c, Date__c FROM Show__c WHERE Id =: showId LIMIT 1];
            List<Set_List__c> setListForShow = [SELECT Id FROM Set_List__c WHERE Show__c =: showId];
            if (!shows.isEmpty() && setListForShow.isEmpty()) {
                Show__c show = shows.get(0);
                Set_List__c setList = new Set_List__c(Name = 'SetList for '+show.Name, Length_Hours__c = 0, Length_Minutes__c = 0, Length_Seconds__c = 0, Show__c = showId);
                insert setList;
                System.debug('Set List: '+setList);
                List<Song__c> songs = [SELECT Id, Name, Status__c, Rating__c, Original_Artist__c, Length_Minutes__c, Length_Seconds__c FROM Song__c WHERE Status__c = 'Active'];
                System.debug('Songs before shuffle: '+songs);
                songs = shuffleSongs(songs);
                System.debug('Songs after shuffle: '+songs);
                Set<Id> overPlayedSongsIds = getListOverPlayedSongs();
                Set<Id> setlistSongs = new Set<Id>();
                Integer lowRatingSongs = 0;
                Decimal setListLengthSeconds = 0;
                Decimal showLengthSeconds = (show.Length_Hours__c * 3600) + (show.Length_Minutes__c * 60);
                Integer margin = 120;
                Decimal songLengthSeconds;
                List<Song__c> leftOutSongs = new List<Song__c>();

                for(Song__c song: songs){
                    //If the length of the set list is not close enough to the show length, keep adding songs
                    if(setListLengthSeconds < (showLengthSeconds-margin)){
                        //A song can only be included if it hasn't been played more than three times in the last 30 days
                        if(!overPlayedSongsIds.contains(song.Id)){
                            //If the song has low rating, check low rating song counter
                            if(Integer.valueOf(song.Rating__c) < 3){
                                //If set list has less than 3 songs with low rating, the song can be added
                                if(lowRatingSongs < 3){
                                    setlistSongs.add(song.Id);
                                    lowRatingSongs++;
                                    System.debug('Song added >> '+song);
                                    songLengthSeconds = (song.Length_Minutes__c * 60) + song.Length_Seconds__c;
                                    setListLengthSeconds += songLengthSeconds;
                                    System.debug('Song length in seconds is '+songLengthSeconds);
                                    System.debug('Set List Length is now '+setListLengthSeconds+' seconds.');
                                }
                                //Add to the left out list to be added just in case it is needed after fetching through all the songs to complete the minimum length for the set list
                                else {
                                    leftOutSongs.add(song);
                                }
                            }
                            //The song can be added
                            else {
                                setlistSongs.add(song.Id);
                                System.debug('Song added >> '+song);
                                songLengthSeconds = (song.Length_Minutes__c * 60) + song.Length_Seconds__c;
                                setListLengthSeconds += songLengthSeconds;
                                System.debug('Song length in seconds is '+songLengthSeconds);
                                System.debug('Set List Length is now '+setListLengthSeconds+' seconds.');
                            }
                        }//if
                    }//if
                }//for
                //If after iterating through the whole song repertoire the set list length is still behind the margin and there are songs in the left out list, then add them to the set list until reaching the minimum length
                if(setListLengthSeconds < (showLengthSeconds-margin) && !leftOutSongs.isEmpty()){
                    for(Song__c song: leftOutSongs){
                        //If the set list is still not close enough, add the song
                        if(setListLengthSeconds < (showLengthSeconds-margin)){
                            setlistSongs.add(song.Id);
                            lowRatingSongs++;
                            System.debug('Song added >> '+song);
                            songLengthSeconds = (song.Length_Minutes__c * 60) + song.Length_Seconds__c;
                            setListLengthSeconds += songLengthSeconds;
                            System.debug('Song length in seconds is '+songLengthSeconds);
                            System.debug('Set List Length is now '+setListLengthSeconds+' seconds.');
                        }
                    }
                }
                List<Set_List_Song__c> setListSongsToInsert = new List<Set_List_Song__c>();
                for(Id songId: setlistSongs){
                    Set_List_Song__c setListItem = new Set_List_Song__c(Set_List__c = setList.Id, Song__c = songId);
                    setListSongsToInsert.add(setListItem);
                }
                insert setListSongsToInsert;
                //Set the Set List Length in hours, minutes and seconds
                setList.Length_Seconds__c = Math.mod(Integer.ValueOf(setListLengthSeconds),60);
                setList.Length_Hours__c = setListLengthSeconds/60;
                setList.Length_Minutes__c = Math.mod(Integer.ValueOf(setList.Length_Hours__c),60);
                setList.Length_Hours__c = setList.Length_Hours__c/60;
                System.debug('Set List Length: '+setList.Length_Hours__c+' hrs '+setList.Length_Minutes__c+' min '+setList.Length_Seconds__c+' sec.');
                update setList;
                System.debug('Set List finished: '+setList);
                return setList.Id;
            }
            //If there is already a set list for the show, return it
            else if (!setListForShow.isEmpty()){
                System.debug('There was an existing Set_List__c for the Show: '+setListForShow.get(0));
                return setListForShow.get(0).Id;
            }
            //Show is missing, return null
            else {
                System.debug('ShowId is missing in Show__c records');
                return null;
            }
        } else {
            System.debug('Missing CRUD permissions for the user to use this LWC. User mus be able to read Show__c and Song__c, create and update Set_List__c and create Set_List_Song__c.');
            return null;
        }
    }

    /**
     * @description Method that returns a list of Song__c with the song's data, for every song in the set list
     * @version 1.0
     * @since 1.0
     * @author Andrea Fernandez <andrea.f@globant.com>
     * @param showId Id of the show the set list is from
     * @return songsData List of Songs for the Show Set List
     * **/
    @AuraEnabled
    public static List<Song__c> getSetList(String showId){
        try {
            Id setListId = createSetList(showId);
            if(setListId != null){
                System.debug('Almost there...');
                Set<Id> songIds;
                List<Set_List_Song__c> setListSongs = [SELECT Song__c FROM Set_List_Song__c WHERE Set_List__c =: setListId];
                Set<Id> setListSongsIds = new Set<Id>();
                for(Set_List_Song__c setListSong: setListSongs){
                    setListSongsIds.add(setListSong.Song__c);
                }
                System.debug('Final Songs Ids:' +setListSongs);
                List<Song__c> songsData = [SELECT Name, Status__c, Rating__c, Original_Artist__c, Length_Minutes__c, Length_Seconds__c FROM Song__c WHERE Id IN :setListSongsIds];
                System.debug('Final Songs:' +songsData);
                return songsData;
            } else {
                throw new AuraHandledException('ERROR: Show could not be found.');
            }            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description Method that returns a String representing the set list length in HH:MM:SS format
     * @version 1.0
     * @since 1.0
     * @author Andrea Fernandez <andrea.f@globant.com>
     * @param showId Id of the show the set list is from
     * @return setListLength string with the set list length in HH:MM:SS format
     * **/
    @AuraEnabled
    public static String getSetListLength(String showId){
        try {
            List<Set_List__c> setLists = [SELECT Length_Hours__c, Length_Minutes__c, Length_Seconds__c FROM Set_List__c WHERE Show__c = :showId LIMIT 1];
            if(!setLists.isEmpty()){
                Set_List__c setList = setLists.get(0);
                String setListLength = '';
                if(setList.Length_Hours__c >= 1){
                    setListLength += Integer.ValueOf(setList.Length_Hours__c) + ' hrs ';
                }
                setListLength += setList.Length_Minutes__c + ' min ';
                setListLength += setList.Length_Seconds__c + ' sec.';
                return setListLength;
            } else {
                System.debug('ERROR: Set List could not be found.');
                return '0';
            }            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    /**
     * @description Method to get the list of Song__c taht have been played more than 3 times in the last 30 days
     * @version 1.0
     * @since 1.0
     * @author Andrea Fernandez <andrea.f@globant.com>
     * @return Id set of the songs that have been played more than 3 times in the past 30 days
     * **/
    public static Set<Id> getListOverPlayedSongs(){
        List<Show__c> pastShowsOfTheMonth = [SELECT Id, Name, Date__c FROM Show__c WHERE Date__c >= :Date.Today().addDays(-30) AND Date__c <= TODAY];
        System.debug('Shows of the current month: '+pastShowsOfTheMonth);
        Set<Id> pastShowsOfTheMonthIds = (new Map<Id,Show__c>(pastShowsOfTheMonth)).keySet();
        List<Set_List__c> pastShowsSetLists = [SELECT Id, Name, Length_Hours__c, Length_Minutes__c, Length_Seconds__c FROM Set_List__c WHERE Show__c IN :pastShowsOfTheMonth];
        System.debug('Set lists of the shows of the current month: '+pastShowsSetLists);
        Set<Id> pastShowsSetListsIds = (new Map<Id,Set_List__c>(pastShowsSetLists)).keySet();
        List<Set_List_Song__c> pastShowsSetListsSongs = [SELECT Id, Song__c, Set_List__c FROM Set_List_Song__c WHERE Set_List__c IN :pastShowsSetLists];
        System.debug('Songs in the set lists of the shows of the current month: '+pastShowsSetListsSongs);
        Set<Id> pastShowsSetListsSongsUniqueIds = new Set<Id>();
        for(Set_List_Song__c setListSong: pastShowsSetListsSongs){
            if(!pastShowsSetListsSongsUniqueIds.contains(setListSong.Song__c)){
                pastShowsSetListsSongsUniqueIds.add(setListSong.Song__c);
            }
        }
        System.debug('Unique song id set: '+pastShowsSetListsSongsUniqueIds);
        Integer count = 0;
        Set<Id> overPlayedSongIds = new Set<Id>();
        for(Id songId: pastShowsSetListsSongsUniqueIds){
            for(Set_List_Song__c setlistSong: pastShowsSetListsSongs){
                if(songId == setlistSong.Id){
                    count++;
                }
            }
            if(count > 3){
                overPlayedSongIds.add(songId);
            }
            count=0;
        }
        return overPlayedSongIds;
    }

    /**
     * @description Method to shuffle a list of Song__c
     * @version 1.0
     * @since 1.0
     * @author Andrea Fernandez <andrea.f@globant.com>
     * @param songList List of Song__c to be shuffled
     * @return songList List of Song__c after the shuffle
     * **/
    public static List<Song__c> shuffleSongs(List<Song__c> songList){     
        Song__c song;
        integer randomIndex;
        integer currentIndex = songList.size();         
        while (currentIndex != 0) {
            randomIndex = integer.valueOf(Math.floor(Math.random() * currentIndex));
            currentIndex -= 1;
            song = songList[currentIndex];
            songList[currentIndex] = songList[randomIndex];
            songList[randomIndex] = song;
        }
        return songList;
    }
}