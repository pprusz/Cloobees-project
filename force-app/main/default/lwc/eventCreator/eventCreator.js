import { LightningElement, track, wire, api } from 'lwc';
import { createRecord } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';
import { getRecord } from 'lightning/uiRecordApi';
import EVENT_OBJECT from '@salesforce/schema/Event__c';
import NAME_FIELD from '@salesforce/schema/Event__c.Name';
import NAME__C_FIELD from '@salesforce/schema/Event__c.Name__c';
import ORGANIZER_FIELD from '@salesforce/schema/Event__c.Event_Organizer__c';
import START_DATE_FIELD from '@salesforce/schema/Event__c.Start_DateTime__c';
import END_DATE_FIELD from '@salesforce/schema/Event__c.End_Date_Time__c';
import MAX_ATTENDEES_FIELD from '@salesforce/schema/Event__c.Max_Seats__c';
import EVENT_DETAIL_FIELD from '@salesforce/schema/Event__c.Event_Detail__c';

export default class EventForm extends NavigationMixin(LightningElement) {
    @api 
        set recordId(value) {
            this._recordId = value;
            console.log(`record z API${this._recordId}`);
        }
        get recordId() {
            return this._recordId;
        }
        
    @track name = '';
    @track name__c = '';
    @track organizer = '';
    @track startDateTime = '';
    @track endDateTime = '';
    @track maxSeats = '';
    @track eventDetail = '';
    
    connectedCallback(){
        console.log(this.recordId)
    }

    handleNameChange(event) {
        this.name = event.target.value;
        this.name__c = event.target.value;
    }

    handleStartDateTimeChange(event) {
        this.startDateTime = event.target.value;
    }

    handleEndDateTimeChange(event) {
        this.endDateTime = event.target.value;
    }

    handleMaxSeatsChange(event) {
        this.maxSeats = event.target.value;
    }

    handleEventDetailChange(event) {
        this.eventDetail = event.target.value;
    }

    saveRecord() {
        const fields = {};
        fields[NAME_FIELD.fieldApiName] = this.name;
        fields[NAME__C_FIELD.fieldApiName] = this.name__c;
        fields[ORGANIZER_FIELD.fieldApiName] = this.recordId;
        fields[START_DATE_FIELD.fieldApiName] = this.startDateTime;
        fields[END_DATE_FIELD.fieldApiName] = this.endDateTime;
        fields[MAX_ATTENDEES_FIELD.fieldApiName] = this.maxSeats;
        fields[EVENT_DETAIL_FIELD.fieldApiName] = this.eventDetail;
        const recordInput = { apiName: EVENT_OBJECT.objectApiName, fields };

        createRecord(recordInput)
            .then(event => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Event created',
                        variant: 'success'
                    })
                );
                this[NavigationMixin.Navigate]({
                    type: 'standard__recordPage',
                    attributes: {
                        recordId: event.id,
                        objectApiName: 'Event__c',
                        actionName: 'view'
                    }
                });
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating record',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}
