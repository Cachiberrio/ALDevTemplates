table 85002 EXSExpenseSheetLine
{
    Caption = 'Expense Sheet Line';

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(6; Date; Date)
        {
            Caption = 'Date';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        EXSExpenseSheetCommentLine: Record EXSExpenseSheetCommentLine;
    begin
        EXSExpenseSheetCommentLine.Reset;
        EXSExpenseSheetCommentLine.SetRange("Table Name", EXSExpenseSheetCommentLine."Table Name"::Line);
        EXSExpenseSheetCommentLine.SetRange("Document No.", "Document No.");
        EXSExpenseSheetCommentLine.SetRange("Document Line No.", "Line No.");
        EXSExpenseSheetCommentLine.DeleteAll(false);
    end;

    trigger OnInsert()
    begin
        GetEXSExpenseSheetHeader;
        if Date = 0D then
            Date := EXSExpenseSheetHeader."Posting Date"
    end;

    var
        EXSExpenseSheetHeader: Record EXSExpenseSheetHeader;

    local procedure GetEXSExpenseSheetHeader()
    begin
        if not EXSExpenseSheetHeader.Get("Document No.") then
            EXSExpenseSheetHeader.Init;
    end;
}

