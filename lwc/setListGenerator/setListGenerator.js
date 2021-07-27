import getSetList from '@salesforce/apex/SetListGeneratorController.getSetList';
import getSetListLength from '@salesforce/apex/SetListGeneratorController.getSetListLength';

import { LightningElement, api, track } from 'lwc';

const columns = [
    { label: 'Song Name', fieldName: 'Name' },
    { label: 'Original Artist', fieldName: 'Original_Artist__c', type: 'text' },
    { label: 'Minutes', fieldName: 'Length_Minutes__c', type: 'number' },
    { label: 'Seconds', fieldName: 'Length_Seconds__c', type: 'number' },
    { label: 'Rating', fieldName: 'Rating__c', type: 'number' },
    { label: 'Status', fieldName: 'Status__c', type: 'text' },
];

export default class SetListGenerator extends LightningElement {
    @api recordId;
    columns = columns;
    error;
    ready;
    @track setListLength = [];
    @track setlist = [];

    connectedCallback() {
        getSetList({ 
            showId: this.recordId 
        }).then ( result => {
            console.log('Songs retrieved:' + JSON.stringify(result));
            this.setlist = result;
                getSetListLength({
                    showId: this.recordId 
                }).then ( result => {
                    console.log('Set List length:' + result);
                    console.log('this.setlistLength: '+this.setlistLength);
                    this.setlistLength = result;
                    this.ready = true;
                    console.log('this.setlistLength: '+this.setlistLength);
                }).catch ( error => {
                    this.setlistLength = undefined;
                    this.error = 'Unkwnown error';
                    this.ready = false;
                    if (Array.isArray(error.body)) {
                        this.error = error.body.map(e => e.message).join(': ');
                    } else if (typeof error.body.message === 'string') {
                        this.error = error.body.message;
                    }
                });
        }).catch ( error => {
            this.setlist = undefined;
            this.error = 'Unkwnown error';
            if (Array.isArray(error.body)) {
                this.error = error.body.map(e => e.message).join(': ');
            } else if (typeof error.body.message === 'string') {
                this.error = error.body.message;
            }
        });
    }
    
}