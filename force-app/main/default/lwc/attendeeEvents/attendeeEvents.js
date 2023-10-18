import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import getPastEvents from '@salesforce/apex/attendeeEventsController.getPastEvents';
import getUpcomingEvents from '@salesforce/apex/attendeeEventsController.getUpcomingEvents';

const ATTENDEE_FIELDS = ['Attendee__c.Name'];

export default class AttendeeEvents extends LightningElement {
    @api recordId;
    @track attendeeName;

    pastEvents;

    pastEventsColumns = [
        { label: 'Event Name', fieldName: 'eventUrl', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank' } },
        { label: 'Name', fieldName: 'attendeeName', type: 'text' },
        { label: 'Event Date', fieldName: 'startDate', type: 'datetime' },
        { label: 'Location', fieldName: 'locationName', type: 'text' }
    ];

    upcomingEvents;
    
    upcomingEventsColumns = [
        { label: 'Event Name', fieldName: 'eventUrl', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank' } },
        { label: 'Name', fieldName: 'attendeeName', type: 'text' },
        { label: 'Event Date', fieldName: 'startDate', type: 'datetime' },
        { label: 'Location', fieldName: 'locationName', type: 'text' }
    ]

    @wire(getRecord, { recordId: '$recordId', fields: ATTENDEE_FIELDS })
    attendeeRecord({ error, data }) {
        if (data) {
            this.attendeeName = data.fields.Name.value;
        } else if (error) {
            console.log(error);
        }
    }

    @wire(getUpcomingEvents, { attendeeId: '$recordId' })
    wiredUpcomingEvents({ error, data }) {
        if (data) {
            this.upcomingEvents = data.map(event => {
                const eventDate = new Date(event.Start_DateTime__c);
                return {
                    ...event,
                    attendeeName: this.attendeeName,
                    eventUrl: `/lightning/r/Event/${event.Id}/view`,
                    locationName: event.Location__r.Name,
                    startDate: eventDate.toLocaleDateString('en-GB')
                };
            });
        } else if (error) {
            console.log(error);
        }
    }

    @wire(getPastEvents, { attendeeId: '$recordId' })
    wiredPastEvents({ error, data }) {
        if (data) {
            this.pastEvents = data.map(event => {
                const eventDate = new Date(event.Start_DateTime__c);
                return {
                    ...event,
                    attendeeName: this.attendeeName,
                    eventUrl: `/lightning/r/Event/${event.Id}/view`,
                    locationName: event.Location__r.Name,
                    startDate: eventDate.toLocaleDateString('en-GB')
                };
            });
        } else if (error) {
            console.log(error);
        }
    }
}