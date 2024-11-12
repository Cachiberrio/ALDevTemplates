table 85071 MAETableNameCommentLine
{
    Caption = 'MAETableCaptionENU Comment Line';

    fields
    {
        field(1; "Table Name"; Option)
        {
            Caption = 'Table Name';
            OptionCaption = 'MAETableCaptionENU';
            OptionMembers = MAETableName;
        }
        field(2; "MAETableName No."; Code[20])
        {
            Caption = 'MAETableCaptionENU No.';
        }
        field(4; "Code"; Code[20])
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
        key(Key1; "Table Name", "MAETableName No.", "Code", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    [Scope('Cloud')]
    procedure SetupNewLine()
    var
        MasterTableNameCommentLine: Record MAETableNameCommentLine;
    begin
        MasterTableNameCommentLine.SetRange("Table Name", "Table Name");
        MasterTableNameCommentLine.SetRange("MAETableName No.", "MAETableName No.");
        MasterTableNameCommentLine.SetRange(Date, WorkDate);
        if not MasterTableNameCommentLine.FindFirst then
            Date := WorkDate;
    end;
}

