import { LightningElement, api, wire } from 'lwc';
import { getRecord } from 'lightning/uiRecordApi';
import NAME_FIELD from '@salesforce/schema/Event__c.Name';
import NAME__C_FIELD from '@salesforce/schema/Event__c.Name__c';
import ORGANIZER_FIELD from '@salesforce/schema/Event__c.Event_Organizer__c';
import START_DATE_FIELD from '@salesforce/schema/Event__c.Start_DateTime__c';
import END_DATE_FIELD from '@salesforce/schema/Event__c.End_Date_Time__c';
import MAX_ATTENDEES_FIELD from '@salesforce/schema/Event__c.Max_Seats__c';
import EVENT_DETAIL_FIELD from '@salesforce/schema/Event__c.Event_Detail__c';
import RECURRING_FIELD from '@salesforce/schema/Event__c.Recurring__c';
import CREATED_BY_FIELD from '@salesforce/schema/Event__c.CreatedById';
import EVENT_TYPE_FIELD from '@salesforce/schema/Event__c.Event_Type__c';
import FREQUENCY_FIELD from '@salesforce/schema/Event__c.Frequency__c';
import LIVE_FIELD from '@salesforce/schema/Event__c.Live__c';
import LOCATION_FIELD from '@salesforce/schema/Event__c.Location__c';
import LOCATION_VERIFIED_FIELD from '@salesforce/schema/Event__c.Location_Verified__c';
import REMAINING_SEATS_FIELD from '@salesforce/schema/Event__c.Remaining_Seats__c';
import STATUS_FIELD from '@salesforce/schema/Event__c.Status__c';
import PEOPLE_ATTENDING_FIELD from '@salesforce/schema/Event__c.People_Attending__c';
import ORGANIZER_NAME_FIELD from '@salesforce/schema/Event__c.Event_Organizer__r.Name';
import LOCATION_NAME_FIELD from '@salesforce/schema/Event__c.Location__r.Name';
import CREATED_BY_NAME_FIELD from '@salesforce/schema/Event__c.CreatedBy.Name';
import EVENT_SPEAKERS from '@salesforce/schema/Event_Speaker__c.Event__c';
import getEventSpeakers from '@salesforce/apex/EventDetailController.getEventSpeakers';
import getLocation from '@salesforce/apex/EventDetailController.getLocation';
import getEventAttendees from '@salesforce/apex/EventDetailController.getEventAttendees';

export default class EventDetail extends LightningElement {
    @api recordId;

    speakers;

    columnsSpeakers = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Email', fieldName: 'Email__c', type: 'email' }
    ];

    attendees;

    columnsAttendees = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Company Name', fieldName: 'Company_Name__c', type: 'text' },
        { label: 'Email', fieldName: 'Email__c', type: 'email' },
        { label: 'Location', fieldName: 'LocationName', type: 'text' }        
    ];

    location;

    columnsLocation = [
        { label: 'Name', fieldName: 'Name', type: 'text' },
        { label: 'Street', fieldName: 'Street__c', type: 'text' },
        { label: 'City', fieldName: 'City__c', type: 'text' },
        { label: 'Postal Code', fieldName: 'Postal_Code__c', type: 'text' },
    ]
    
    eventDetail;

    eventDetailFields = [
        NAME_FIELD,
        NAME__C_FIELD,
        START_DATE_FIELD,
        END_DATE_FIELD,
        ORGANIZER_FIELD,
        MAX_ATTENDEES_FIELD,
        EVENT_DETAIL_FIELD,
        RECURRING_FIELD,
        CREATED_BY_FIELD,
        EVENT_TYPE_FIELD,
        FREQUENCY_FIELD,
        LIVE_FIELD,
        LOCATION_FIELD,
        LOCATION_VERIFIED_FIELD,
        REMAINING_SEATS_FIELD,
        STATUS_FIELD,
        PEOPLE_ATTENDING_FIELD,
        ORGANIZER_NAME_FIELD,
        LOCATION_NAME_FIELD,
        CREATED_BY_NAME_FIELD
    ];

    @wire(getEventSpeakers, { eventId: '$recordId' })
    wiredSpeakers({ error, data }) {
        if (data) {
            this.speakers = data;
        } else if (error) {
            console.log(error);
        }
    }

    @wire(getEventAttendees, { eventId: '$recordId' })
    wiredAttendees({ error, data }) {
        if (data) {
            this.attendees = data.map(attendee => {
                return {
                    ...attendee,
                    LocationName: attendee.Location__r.Name
                };
            });
        } else if (error) {
            console.log(error);
        }
    }
    
    @wire(getLocation, { eventId: '$recordId' })
    wiredLocation({ error, data }) {
        if (data) {
            this.location = data;
        } else if (error) {
            console.log(error);
        }
    }

    @wire(getRecord, { recordId: '$recordId', fields: '$eventDetailFields' })
    loadEventDetail({ error, data }) {
        if (data) {
            this.eventDetail = {
                name: data.fields.Name.value,
                name_c: data.fields.Name__c.value,
                startDate: data.fields.Start_DateTime__c.value,
                endDate: data.fields.End_Date_Time__c.value,
                maxSeats: data.fields.Max_Seats__c.value,
                eventDetail: data.fields.Event_Detail__c.value,
                requrring: data.fields.Recurring__c.value,
                eventType: data.fields.Event_Type__c.value,
                frequency: data.fields.Frequency__c.value,
                live: data.fields.Live__c.value,
                locationVerified: data.fields.Location_Verified__c.value,
                remainingSeats: data.fields.Remaining_Seats__c.value,
                eventStatus: data.fields.Status__c.value,
                peopleAttending: data.fields.People_Attending__c.value,
                organizer: data.fields.Event_Organizer__c.value,
                created: data.fields.CreatedById.value,
                location: data.fields.Location__c.value,
                organizerName: data.fields.Event_Organizer__r,
                locationName: data.fields.Location__r,
                createdName: data.fields.CreatedBy
            };
        } else if (error) {
            console.error('Error loading event detail', error);
        }
    }
}
