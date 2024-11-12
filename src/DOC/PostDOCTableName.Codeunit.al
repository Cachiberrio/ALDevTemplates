codeunit 85001 PostDOCTableName
{
    TableNo = DOCTableNameHeader;

    trigger OnRun()
    begin
        ClearAll;
        DOCTableNameHeader := Rec;
        DOCTableNameHeader.TestField("Posting Date");
        if GenJnlCheckLine.DateNotAllowed(DOCTableNameHeader."Posting Date") then
            DOCTableNameHeader.FieldError("Posting Date", Text003);
        Window.Open(Text004 + Text005);
        DOCTableNameHeaderProcess;
        DOCTableNameLinesProcess;
        CreatePostedDOCTableName;
        DeleteDOCTableName;
    end;

    var
        Text001: Label 'There is nothing to post.';
        Text002: Label 'Posting lines              #2######\';
        DOCTableNameHeader: Record DOCTableNameHeader;
        Text003: Label 'is not within your range of allowed posting dates.';
        Text004: Label 'Posting DOCTableCaptionENU';
        Text005: Label 'Processing Lines #1###';
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        Window: Dialog;
        RecordCount: Integer;
        RecordCounter: Integer;

    local procedure DOCTableNameHeaderProcess()
    begin
    end;

    local procedure DOCTableNameLinesProcess()
    var
        DOCTableNameLine: Record DOCTableNameLine;
    begin
        DOCTableNameLine.Reset;
        DOCTableNameLine.SetRange("Document No.", DOCTableNameHeader."No.");
        if DOCTableNameLine.FindSet then begin
            RecordCount := DOCTableNameLine.Count;
            RecordCounter := 0;
            repeat
                RecordCounter += 1;
                Window.Update(1, Round(10000 * RecordCounter / RecordCount, 1));
            until DOCTableNameLine.Next = 0;
        end else
            Error(Text001);
    end;

    local procedure CreatePostedDOCTableName()
    var
        PostedDOCTableNameHeader: Record PostedDOCTableNameHeader;
        DOCTableNameLine: Record DOCTableNameLine;
        PostedDOCTableNameLine: Record PostedDOCTableNameLine;
    begin
        PostedDOCTableNameHeader.TransferFields(DOCTableNameHeader);
        PostedDOCTableNameHeader.Insert;

        DOCTableNameLine.Reset;
        DOCTableNameLine.SetRange("Document No.", DOCTableNameHeader."No.");
        if DOCTableNameLine.FindSet then
            repeat
                PostedDOCTableNameLine.TransferFields(DOCTableNameLine);
                PostedDOCTableNameLine.Insert;
            until DOCTableNameLine.Next = 0;
    end;

    local procedure DeleteDOCTableName()
    var
        HistCabDocumento: Record PostedDOCTableNameHeader;
        LinDocumento: Record DOCTableNameLine;
        HistLinDocumento: Record PostedDOCTableNameLine;
    begin
        DOCTableNameHeader.Delete(true);
    end;
}

