codeunit 85045 DIAJournalNameJnlPostPrint
{
    TableNo = DIAJournalNameJournalLine;

    trigger OnRun()
    begin
        DIAJournalNameJournalLine.Copy(Rec);
        Code;
        Rec.Copy(DIAJournalNameJournalLine);
    end;

    var
        Text000: Label 'cannot be filtered when posting recurring journals';
        Text001: Label 'Do you want to post the journal lines and print the posting report?';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. ';
        Text005: Label 'You are now in the %1 journal.';
        DIAJournalNameJournalTemplate: Record DIAJournalNameJournalTemplate;
        DIAJournalNameJournalLine: Record DIAJournalNameJournalLine;
        DIAJournalNameJnlPostBatch: Codeunit DIAJournalNameJnlPostBatch;
        TempJournalBatch: Code[10];

    local procedure "Code"()
    begin
        DIAJournalNameJournalTemplate.Get(DIAJournalNameJournalLine."Journal Template Name");
        DIAJournalNameJournalTemplate.TestField("Posting Report ID");

        if not Confirm(Text001) then
            exit;

        TempJournalBatch := DIAJournalNameJournalLine."Journal Batch Name";

        DIAJournalNameJnlPostBatch.Run(DIAJournalNameJournalLine);

        REPORT.Run(DIAJournalNameJournalTemplate."Posting Report ID", false, false);

        if DIAJournalNameJournalLine."Line No." = 0 then
            Message(Text002)
        else
            if TempJournalBatch = DIAJournalNameJournalLine."Journal Batch Name" then
                Message(Text003)
            else
                Message(
                  Text004 +
                  Text005,
                  DIAJournalNameJournalLine."Journal Batch Name");

        if not DIAJournalNameJournalLine.Find('=><') or (TempJournalBatch <> DIAJournalNameJournalLine."Journal Batch Name") then begin
            DIAJournalNameJournalLine.Reset;
            DIAJournalNameJournalLine.FilterGroup(2);
            DIAJournalNameJournalLine.SetRange("Journal Template Name", DIAJournalNameJournalLine."Journal Template Name");
            DIAJournalNameJournalLine.SetRange("Journal Batch Name", DIAJournalNameJournalLine."Journal Batch Name");
            DIAJournalNameJournalLine.FilterGroup(0);
            DIAJournalNameJournalLine."Line No." := 1;
        end;
    end;
}

