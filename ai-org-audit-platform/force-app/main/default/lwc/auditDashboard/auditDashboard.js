import { LightningElement, wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { refreshApex } from '@salesforce/apex';

import getDashboardSummary from '@salesforce/apex/AuditDashboardController.getDashboardSummary';
import getLatestFindings from '@salesforce/apex/AuditDashboardController.getLatestFindings';
import getRecentRuns from '@salesforce/apex/AuditDashboardController.getRecentRuns';

export default class AuditDashboard extends LightningElement {
    summary;
    findings = [];
    runs = [];

    wiredSummaryResult;
    wiredFindingsResult;
    wiredRunsResult;

    @wire(getDashboardSummary)
    wiredSummary(result) {
        this.wiredSummaryResult = result;
        const { data, error } = result;

        if (data) {
            this.summary = data;
        }

        if (error) {
            console.error(error);
        }
    }

    @wire(getLatestFindings)
    wiredFindings(result) {
        this.wiredFindingsResult = result;
        const { data, error } = result;

        if (data) {
            this.findings = data.map((finding) => ({
                ...finding,
                severityClass: this.getSeverityClass(finding.severity)
            }));
        }

        if (error) {
            console.error(error);
        }
    }

    @wire(getRecentRuns)
    wiredRuns(result) {
        this.wiredRunsResult = result;
        const { data, error } = result;

        if (data) {
            this.runs = data;
        }

        if (error) {
            console.error(error);
        }
    }

    get healthClass() {
        if (!this.summary) {
            return 'healthBadge neutral';
        }
        if (this.summary.healthScore >= 80) {
            return 'healthBadge success';
        }
        if (this.summary.healthScore >= 50) {
            return 'healthBadge warning';
        }
        return 'healthBadge danger';
    }

    get healthLabel() {
        if (!this.summary) {
            return 'No data';
        }
        if (this.summary.healthScore >= 80) {
            return 'Excellent';
        }
        if (this.summary.healthScore >= 50) {
            return 'Needs Attention';
        }
        return 'Critical';
    }

    get severityBars() {
        if (!this.summary) {
            return [];
        }
        const counts = [
            { label: 'Critical', count: this.summary.criticalCount, colorClass: 'barFill criticalBar' },
            { label: 'High', count: this.summary.highCount, colorClass: 'barFill highBar' },
            { label: 'Medium', count: this.summary.mediumCount, colorClass: 'barFill mediumBar' },
            { label: 'Low', count: this.summary.lowCount, colorClass: 'barFill lowBar' }
        ];
        const total = Math.max(this.summary.totalFindings, 1);
        return counts.map((item) => {
            const width = Math.round((item.count / total) * 100);
            return {
                ...item,
                widthStyle: `width: ${width}%;`
            };
        });
    }

    get trendPoints() {
        if (!this.runs || !this.runs.length) {
            return [];
        }
        const points = this.runs
            .slice(0, 5)
            .map((run, index) => ({
                name: run.Name || `Run ${index + 1}`,
                score: run.Overall_Score__c || 0
            }))
            .reverse();
        const maxScore = Math.max(...points.map((item) => item.score), 100);
        return points.map((item) => ({
            ...item,
            widthStyle: `width: ${Math.round((item.score / maxScore) * 100)}%;`
        }));
    }

    get runColumns() {
        return [
            { label: 'Run', fieldName: 'Name' },
            { label: 'Status', fieldName: 'Status__c' },
            { label: 'Score', fieldName: 'Overall_Score__c', type: 'number' },
            { label: 'Total Findings', fieldName: 'Total_Findings__c', type: 'number' },
            { label: 'Start Time', fieldName: 'Scan_Start_Time__c', type: 'date' }
        ];
    }

    getSeverityClass(severity) {
        const normalized = (severity || '').toLowerCase();
        if (normalized === 'critical') {
            return 'severityBadge critical';
        }
        if (normalized === 'high') {
            return 'severityBadge high';
        }
        if (normalized === 'medium') {
            return 'severityBadge medium';
        }
        return 'severityBadge low';
    }

    handleRunAudit() {
        Promise.all([
            refreshApex(this.wiredSummaryResult),
            refreshApex(this.wiredFindingsResult),
            refreshApex(this.wiredRunsResult)
        ])
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Audit refreshed',
                        message: 'Dashboard data has been updated.',
                        variant: 'success'
                    })
                );
            })
            .catch((error) => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Unable to refresh',
                        message: error.body ? error.body.message : error.message,
                        variant: 'error'
                    })
                );
            });
    }
}