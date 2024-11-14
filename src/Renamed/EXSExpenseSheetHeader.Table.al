table 85000 EXSExpenseSheetHeader
{

    Caption = 'Expense Sheet Header';

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
        DocumentNameCommentLine: Record EXSExpenseSheetCommentLine;
        DocumentNameLine: Record EXSExpenseSheetLine;
    begin
        DocumentNameLine.Reset;
        DocumentNameLine.SetRange("Document No.", "No.");
        DocumentNameLine.DeleteAll(true);

        DocumentNameCommentLine.Reset;
        DocumentNameCommentLine.SetRange("Table Name", DocumentNameCommentLine."Table Name"::Header);
        DocumentNameCommentLine.SetRange("Document No.", "No.");
        DocumentNameCommentLine.DeleteAll(false);
    end;

    trigger OnInsert()
    var
        EXSExpenseSheetHeader: Record EXSExpenseSheetHeader;
    begin
        if "No." = '' then begin
            EXSExpenseSheetSetup.Get;
            EXSExpenseSheetSetup.TestField("Expense Sheet No. Series");

            "No. Series" := EXSExpenseSheetSetup."Expense Sheet No. Series";
            if NoSeries.AreRelated("No. Series", xRec."No. Series") then
                "No. Series" := xRec."No. Series";
            "No." := NoSeries.GetNextNo("No. Series");
            while EXSExpenseSheetHeader.Get("No.") do
                "No." := NoSeries.GetNextNo("No. Series");
        end;
    end;

    var
        EXSExpenseSheetSetup: Record EXSExpenseSheetSetup;
        NoSeries: Codeunit "No. Series";

    procedure AssistEdit(OldEXSExpenseSheetHeader: Record EXSExpenseSheetHeader): Boolean
    var
        EXSExpenseSheetHeader: Record EXSExpenseSheetHeader;
    begin
        OldEXSExpenseSheetHeader := Rec;
        EXSExpenseSheetSetup.Get();
        EXSExpenseSheetSetup.TestField("Expense Sheet No. Series");
        if NoSeries.LookupRelatedNoSeries(EXSExpenseSheetSetup."Expense Sheet No. Series", OldEXSExpenseSheetHeader."No. Series", EXSExpenseSheetHeader."No. Series") then begin
            EXSExpenseSheetHeader."No." := NoSeries.GetNextNo(EXSExpenseSheetHeader."No. Series");
            Rec := OldEXSExpenseSheetHeader;
            exit(true);
        end;
    end;
}

