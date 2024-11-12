table 85003 PostedDOCTableNameLine
{
    Caption = 'Posted DOCTableCaptionENU Line';

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
        LinComentario: Record DOCTableNameCommentLine;
    begin
        LinComentario.Reset;
        LinComentario.SetRange("Table Name", LinComentario."Table Name"::Line);
        LinComentario.SetRange("Document No.", "Document No.");
        LinComentario.SetRange("Document Line No.", "Line No.");
        LinComentario.DeleteAll(false);
    end;
}

