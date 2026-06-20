import { LightningElement, wire } from 'lwc';

import getDashboardSummary
from '@salesforce/apex/AuditDashboardController.getDashboardSummary';

import getLatestFindings
from '@salesforce/apex/AuditDashboardController.getLatestFindings';

import getRecentRuns
from '@salesforce/apex/AuditDashboardController.getRecentRuns';

export default class AuditDashboard
extends LightningElement {

    summary;

    findings;

    runs;

    @wire(getDashboardSummary)
    wiredSummary({ error, data }) {

        if(data) {
            this.summary = data;
        }

        if(error) {
            console.error(error);
        }
    }

    @wire(getLatestFindings)
    wiredFindings({ error, data }) {

        if(data) {
            this.findings = data;
        }

        if(error) {
            console.error(error);
        }
    }

    @wire(getRecentRuns)
    wiredRuns({ error, data }) {

        if(data) {
            this.runs = data;
        }

        if(error) {
            console.error(error);
        }
    }

}