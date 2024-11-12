table 85002 DOCTableNameLine
{
    Caption = 'DOCTableCaptionENU Line';

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
        DOCTableNameCommentLine: Record DOCTableNameCommentLine;
    begin
        DOCTableNameCommentLine.Reset;
        DOCTableNameCommentLine.SetRange("Table Name", DOCTableNameCommentLine."Table Name"::Line);
        DOCTableNameCommentLine.SetRange("Document No.", "Document No.");
        DOCTableNameCommentLine.SetRange("Document Line No.", "Line No.");
        DOCTableNameCommentLine.DeleteAll(false);
    end;

    trigger OnInsert()
    begin
        GetDOCTableNameHeader;
        if Date = 0D then
            Date := DOCTableNameHeader."Posting Date"
    end;

    var
        DOCTableNameHeader: Record DOCTableNameHeader;

    local procedure GetDOCTableNameHeader()
    begin
        if not DOCTableNameHeader.Get("Document No.") then
            DOCTableNameHeader.Init;
    end;
}

