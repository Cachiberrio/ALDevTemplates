codeunit 85001 PostEXSExpenseSheet
{
    TableNo = EXSExpenseSheetHeader;

    trigger OnRun()
    begin
        ClearAll;
        EXSExpenseSheetHeader := Rec;
        EXSExpenseSheetHeader.TestField("Posting Date");
        if GenJnlCheckLine.DateNotAllowed(EXSExpenseSheetHeader."Posting Date") then
            EXSExpenseSheetHeader.FieldError("Posting Date", Text003);
        Window.Open(Text004 + Text005);
        EXSExpenseSheetHeaderProcess;
        EXSExpenseSheetLinesProcess;
        CreatePostedEXSExpenseSheet;
        DeleteEXSExpenseSheet;
    end;

    var
        Text001: Label 'There is nothing to post.';
        Text002: Label 'Posting lines              #2######\';
        EXSExpenseSheetHeader: Record EXSExpenseSheetHeader;
        Text003: Label 'is not within your range of allowed posting dates.';
        Text004: Label 'Posting Expense Sheet';
        Text005: Label 'Processing Lines #1###';
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        Window: Dialog;
        RecordCount: Integer;
        RecordCounter: Integer;

    local procedure EXSExpenseSheetHeaderProcess()
    begin
    end;

    local procedure EXSExpenseSheetLinesProcess()
    var
        EXSExpenseSheetLine: Record EXSExpenseSheetLine;
    begin
        EXSExpenseSheetLine.Reset;
        EXSExpenseSheetLine.SetRange("Document No.", EXSExpenseSheetHeader."No.");
        if EXSExpenseSheetLine.FindSet then begin
            RecordCount := EXSExpenseSheetLine.Count;
            RecordCounter := 0;
            repeat
                RecordCounter += 1;
                Window.Update(1, Round(10000 * RecordCounter / RecordCount, 1));
            until EXSExpenseSheetLine.Next = 0;
        end else
            Error(Text001);
    end;

    local procedure CreatePostedEXSExpenseSheet()
    var
        PostedEXSExpenseSheetHeader: Record PostedEXSExpenseSheetHeader;
        EXSExpenseSheetLine: Record EXSExpenseSheetLine;
        PostedEXSExpenseSheetLine: Record PostedEXSExpenseSheetLine;
    begin
        PostedEXSExpenseSheetHeader.TransferFields(EXSExpenseSheetHeader);
        PostedEXSExpenseSheetHeader.Insert;

        EXSExpenseSheetLine.Reset;
        EXSExpenseSheetLine.SetRange("Document No.", EXSExpenseSheetHeader."No.");
        if EXSExpenseSheetLine.FindSet then
            repeat
                PostedEXSExpenseSheetLine.TransferFields(EXSExpenseSheetLine);
                PostedEXSExpenseSheetLine.Insert;
            until EXSExpenseSheetLine.Next = 0;
    end;

    local procedure DeleteEXSExpenseSheet()
    var
        HistCabDocumento: Record PostedEXSExpenseSheetHeader;
        LinDocumento: Record EXSExpenseSheetLine;
        HistLinDocumento: Record PostedEXSExpenseSheetLine;
    begin
        EXSExpenseSheetHeader.Delete(true);
    end;
}

