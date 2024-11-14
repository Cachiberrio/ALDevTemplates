table 85001 PostedEXSExpenseSheetHeader
{
    Caption = 'Posted Expense Sheet Header';

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
            CalcFormula = Exist(EXSExpenseSheetCommentLine WHERE("Table Name" = CONST(Header),
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
        PostedEXSExpenseSheetLine: Record PostedEXSExpenseSheetLine;
        EXSExpenseSheetCommentLine: Record EXSExpenseSheetCommentLine;
    begin
        PostedEXSExpenseSheetLine.Reset;
        PostedEXSExpenseSheetLine.SetRange("Document No.", "No.");
        PostedEXSExpenseSheetLine.DeleteAll(true);

        EXSExpenseSheetCommentLine.Reset;
        EXSExpenseSheetCommentLine.SetRange("Table Name", EXSExpenseSheetCommentLine."Table Name"::Header);
        EXSExpenseSheetCommentLine.SetRange("Document No.", "No.");
        EXSExpenseSheetCommentLine.SetRange("Document Line No.", 0);
        EXSExpenseSheetCommentLine.DeleteAll(false);
    end;

    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.Run;
    end;
}

