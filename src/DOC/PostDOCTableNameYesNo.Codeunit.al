codeunit 85000 PostDOCTableNameYesNo
{
    TableNo = DOCTableNameHeader;

    trigger OnRun()
    begin
        DOCTableNameHeader.Copy(Rec);
        Code;
        Rec := DOCTableNameHeader;
    end;

    var
        Text001: Label 'Do you really want to post the DOCTableCaptionENU?';
        DOCTableNameHeader: Record DOCTableNameHeader;

    local procedure "Code"()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesPostViaJobQueue: Codeunit "Sales Post via Job Queue";
    begin
        if not Confirm(Text001, false) then
            exit;
        CODEUNIT.Run(CODEUNIT::PostDOCTableName, DOCTableNameHeader);
    end;
}

