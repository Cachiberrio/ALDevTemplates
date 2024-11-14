table 85004 EXSExpenseSheetCommentLine
{
    Caption = 'Expense Sheet Comment Line';

    fields
    {
        field(1; "Table Name"; Option)
        {
            Caption = 'Table Name';
            OptionCaption = 'Header,Line';
            OptionMembers = Header,Line;
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(3; "Document Line No."; Integer)
        {
            Caption = 'Document Line No.';
        }
        field(4; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(6; Date; Date)
        {
            Caption = 'Date';
        }
        field(7; Comment; Text[80])
        {
            Caption = 'Comment';
        }
    }

    keys
    {
        key(Key1; "Table Name", "Document No.", "Document Line No.", "Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    procedure SetupNewLine()
    var
        EXSExpenseSheetCommentLine: Record EXSExpenseSheetCommentLine;
    begin
        EXSExpenseSheetCommentLine.SetRange("Table Name", "Table Name");
        EXSExpenseSheetCommentLine.SetRange("Document No.", "Document No.");
        EXSExpenseSheetCommentLine.SetRange("Document Line No.", "Document Line No.");
        EXSExpenseSheetCommentLine.SetRange(Date, WorkDate);
        if not EXSExpenseSheetCommentLine.FindFirst then
            Date := WorkDate;
    end;
}

