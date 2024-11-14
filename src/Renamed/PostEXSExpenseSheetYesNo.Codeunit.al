codeunit 85000 PostEXSExpenseSheetYesNo
{
    TableNo = EXSExpenseSheetHeader;

    trigger OnRun()
    begin
        EXSExpenseSheetHeader.Copy(Rec);
        Code;
        Rec := EXSExpenseSheetHeader;
    end;

    var
        Text001: Label 'Do you really want to post the Expense Sheet?';
        EXSExpenseSheetHeader: Record EXSExpenseSheetHeader;

    local procedure "Code"()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesPostViaJobQueue: Codeunit "Sales Post via Job Queue";
    begin
        if not Confirm(Text001, false) then
            exit;
        CODEUNIT.Run(CODEUNIT::PostEXSExpenseSheet, EXSExpenseSheetHeader);
    end;
}

