codeunit 85041 DIAJournalNameJnlCheckLine
{
    TableNo = DIAJournalNameJournalLine;

    trigger OnRun()
    begin
        GLSetup.Get;
        RunCheck(Rec);
    end;

    var
        Text000: Label 'cannot be a closing date';
        Text001: Label 'is not within your range of allowed posting dates';
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        AllowPostingFrom: Date;
        AllowPostingTo: Date;

    procedure RunCheck(var DIAJournalNameJournalLine: Record DIAJournalNameJournalLine)
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        OnBeforeCheckDIAJournalNameJournalLine(DIAJournalNameJournalLine);
        if DIAJournalNameJournalLine.EmptyLine() then
            exit;

        DIAJournalNameJournalLine.TestField("Posting Date");

        if DIAJournalNameJournalLine."Posting Date" <> NormalDate(DIAJournalNameJournalLine."Posting Date") then
            DIAJournalNameJournalLine.FieldError("Posting Date", Text000);

        if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
            if UserId <> '' then
                if UserSetup.Get(UserId) then begin
                    AllowPostingFrom := UserSetup."Allow Posting From";
                    AllowPostingTo := UserSetup."Allow Posting To";
                end;
            if (AllowPostingFrom = 0D) and (AllowPostingTo = 0D) then begin
                GLSetup.Get;
                AllowPostingFrom := GLSetup."Allow Posting From";
                AllowPostingTo := GLSetup."Allow Posting To";
            end;
            if AllowPostingTo = 0D then
                AllowPostingTo := 99991231D;
        end;
        if (DIAJournalNameJournalLine."Posting Date" < AllowPostingFrom) or (DIAJournalNameJournalLine."Posting Date" > AllowPostingTo) then
            DIAJournalNameJournalLine.FieldError("Posting Date", Text001);

        if DIAJournalNameJournalLine."Posting Date" <> 0D then
            if DIAJournalNameJournalLine."Posting Date" <> NormalDate(DIAJournalNameJournalLine."Posting Date") then
                DIAJournalNameJournalLine.FieldError("Posting Date", Text000);
        OnAfterCheckDIAJournalNameJournalLine(DIAJournalNameJournalLine);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckDIAJournalNameJournalLine(var JournalNameJournalLine: Record DIAJournalNameJournalLine)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckDIAJournalNameJournalLine(var JournalNameJournalLine: Record DIAJournalNameJournalLine)
    begin
    end;
}

