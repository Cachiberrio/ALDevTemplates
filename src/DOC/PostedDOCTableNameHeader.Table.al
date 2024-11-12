table 85001 PostedDOCTableNameHeader
{
    Caption = 'Posted DOCTableCaptionENU Header';

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Created By User Id."; Code[20])
        {
            Caption = 'Created By User Id.';
            TableRelation = User;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(6; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(7; Comment; Boolean)
        {
            CalcFormula = Exist(DOCTableNameCommentLine WHERE("Table Name" = CONST(Header),
                                                               "Document No." = FIELD("No.")));
            Caption = 'Comment';
            FieldClass = FlowField;
        }
        field(8; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Description)
        {
        }
    }

    trigger OnDelete()
    var
        PostedDOCTableNameLine: Record PostedDOCTableNameLine;
        DOCTableNameCommentLine: Record DOCTableNameCommentLine;
    begin
        PostedDOCTableNameLine.Reset;
        PostedDOCTableNameLine.SetRange("Document No.", "No.");
        PostedDOCTableNameLine.DeleteAll(true);

        DOCTableNameCommentLine.Reset;
        DOCTableNameCommentLine.SetRange("Table Name", DOCTableNameCommentLine."Table Name"::Header);
        DOCTableNameCommentLine.SetRange("Document No.", "No.");
        DOCTableNameCommentLine.SetRange("Document Line No.", 0);
        DOCTableNameCommentLine.DeleteAll(false);
    end;

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.Run;
    end;
}

