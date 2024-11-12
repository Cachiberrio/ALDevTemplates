table 85004 DOCTableNameCommentLine
{
    Caption = 'DOCTableCaptionENU Comment Line';

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
        DOCTableNameCommentLine: Record DOCTableNameCommentLine;
    begin
        DOCTableNameCommentLine.SetRange("Table Name", "Table Name");
        DOCTableNameCommentLine.SetRange("Document No.", "Document No.");
        DOCTableNameCommentLine.SetRange("Document Line No.", "Document Line No.");
        DOCTableNameCommentLine.SetRange(Date, WorkDate);
        if not DOCTableNameCommentLine.FindFirst then
            Date := WorkDate;
    end;
}

