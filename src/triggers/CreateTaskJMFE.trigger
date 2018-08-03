trigger CreateTaskJMFE on Account (after insert) {
    JMFETaskCreationUtilty.createJMFETasks(Trigger.New);
}