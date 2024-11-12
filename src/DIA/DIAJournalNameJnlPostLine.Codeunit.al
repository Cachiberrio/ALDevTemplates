codeunit 85042 DIAJournalNameJnlPostLine
{
    TableNo = DIAJournalNameJournalLine;

    trigger OnRun()
    begin
        RunWithCheck(Rec);
    end;

    var
        DIAJournalNameJournalLine: Record DIAJournalNameJournalLine;
        JournalNameJnlCheckLine: Codeunit DIAJournalNameJnlCheckLine;
        NextEntryNo: Integer;

    procedure RunWithCheck(var DIAJournalNameJournalLine2: Record DIAJournalNameJournalLine)
    begin
        DIAJournalNameJournalLine.Copy(DIAJournalNameJournalLine2);
        Code;
        DIAJournalNameJournalLine2 := DIAJournalNameJournalLine;
    end;

    local procedure "Code"()
    var
        Handled: Boolean;
        DIAJournalNameEntry: Record DIAJournalNameEntry;
    begin
        OnBeforePostlDIAJournalNameJournaLine(DIAJournalNameJournalLine, Handled);
        if Handled then
            exit;
        if DIAJournalNameJournalLine.EmptyLine() then
            exit;
        JournalNameJnlCheckLine.RunCheck(DIAJournalNameJournalLine);
        CreateDIAJournalNameEntry(DIAJournalNameEntry);
        OnAfterPostlDIAJournalNameJournalLine(DIAJournalNameJournalLine, DIAJournalNameEntry);
    end;

    local procedure CreateDIAJournalNameEntry(var DIAJournalNameEntry: Record DIAJournalNameEntry)
    begin
        OnBeforeCreateDIAJournalNameEntry(DIAJournalNameEntry, DIAJournalNameJournalLine);
        NextEntryNo := FindNextEntryNo;
        DIAJournalNameEntry.Init;
        DIAJournalNameEntry."Entry No." := NextEntryNo;
        DIAJournalNameEntry."Journal Batch Name" := DIAJournalNameJournalLine."Journal Batch Name";
        DIAJournalNameEntry."Posting Date" := DIAJournalNameJournalLine."Posting Date";
        DIAJournalNameEntry."Document No." := DIAJournalNameJournalLine."Document No.";
        DIAJournalNameEntry.Description := DIAJournalNameJournalLine.Description;
        DIAJournalNameEntry."Posting No. Series" := DIAJournalNameJournalLine."Posting No. Series";
        DIAJournalNameEntry."Source Code" := DIAJournalNameJournalLine."Source Code";
        DIAJournalNameEntry."Reason Code" := DIAJournalNameJournalLine."Reason Code";
        DIAJournalNameEntry.Insert;
        OnAfterCreateDIAJournalNameEntry(DIAJournalNameEntry, DIAJournalNameJournalLine);
        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure FindNextEntryNo() NextEntryNo: Integer
    var
        DIAJournalNameEntry: Record DIAJournalNameEntry;
    begin
        if NextEntryNo = 0 then begin
            DIAJournalNameEntry.LockTable;
            if DIAJournalNameEntry.FindLast then
                NextEntryNo := DIAJournalNameEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePostlDIAJournalNameJournaLine(var JournalNameJournalLine: Record DIAJournalNameJournalLine; var Habdled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterPostlDIAJournalNameJournalLine(var JournalNameJournalLine: Record DIAJournalNameJournalLine; var JournalNameEntry: Record DIAJournalNameEntry)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateDIAJournalNameEntry(var JournalNameEntry: Record DIAJournalNameEntry; JournalNameJournalLine: Record DIAJournalNameJournalLine)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateDIAJournalNameEntry(var JournalNameEntry: Record DIAJournalNameEntry; JournalNameJournalLine: Record DIAJournalNameJournalLine)
    begin
    end;
}

