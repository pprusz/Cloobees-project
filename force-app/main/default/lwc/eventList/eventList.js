import { LightningElement, track, wire } from 'lwc';
import getEvents from '@salesforce/apex/EventsListController.getEvents';

export default class EventList extends LightningElement {
    @track eventName = '';
    @track startDate = new Date().toISOString().split('T')[0];
    events;

    columnsEvents = [
        { label: 'Name', fieldName: 'Name__c', type: 'text' },
        { label: 'Event Organizer', fieldName: 'Event_Organizer', type: 'text' },
        { label: 'Location', fieldName: 'Location', type: 'text' },
        { label: 'Start Date', fieldName: 'Start_DateTime__c', type: 'date' },
        { label: 'Details', fieldName: 'Event_Detail__c', type: 'text' },
    ];

    handleNameChange(event) {
        this.eventName = event.target.value;
    }

    handleDateChange(event) {
        this.startDate = event.target.value;
    }

    @wire(getEvents, { eventName: '$eventName', startDate: '$startDate' })
    wiredEvents({ error, data }) {
        if (data) {
            this.events = data.map(event => {
                return {
                    Id: event.Id,
                    Name__c: event.Name__c,
                    Event_Organizer: event.Event_Organizer__r ? event.Event_Organizer__r.Name : '',
                    Location: event.Location__r ? event.Location__r.Name : '',
                    Event_Detail__c: event.Event_Detail__c,
                    Start_DateTime__c: event.Start_DateTime__c
                };
            });
        } else if (error) {
            console.log(error);
        }
    }
}
