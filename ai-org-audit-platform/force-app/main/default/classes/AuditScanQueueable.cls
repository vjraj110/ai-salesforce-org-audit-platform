public class AuditScanQueueable implements Queueable {

    public void execute(QueueableContext context) {
        AuditExecutionService.runAudit();
    }
}