table 85041 DIAJournalNameJournalBatch
{
    Caption = 'DIAJournalCaptionENU Journal Batch';
    DrillDownPageID = DIAJournalNameJnlBatches;
    LookupPageID = DIAJournalNameJnlBatches;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = DIAJournalNameJournalTemplate;
        }
        field(2; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";

            trigger OnValidate()
            begin
                if "Reason Code" <> xRec."Reason Code" then begin
                    DIAJournalNameJournalLine.SetRange("Journal Template Name", "Journal Template Name");
                    DIAJournalNameJournalLine.SetRange("Journal Batch Name", Name);
                    DIAJournalNameJournalLine.ModifyAll("Reason Code", "Reason Code");
                    Modify;
                end;
            end;
        }
        field(5; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if "No. Series" <> '' then begin
                    DIAJournalNameJournalTemplate.Get("Journal Template Name");
                    if "No. Series" = "Posting No. Series" then
                        Validate("Posting No. Series", '');
                end;
            end;
        }
        field(6; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if ("Posting No. Series" = "No. Series") and ("Posting No. Series" <> '') then
                    FieldError("Posting No. Series", StrSubstNo(Text001, "Posting No. Series"));
                DIAJournalNameJournalLine.SetRange("Journal Template Name", "Journal Template Name");
                DIAJournalNameJournalLine.SetRange("Journal Batch Name", Name);
                DIAJournalNameJournalLine.ModifyAll("Posting No. Series", "Posting No. Series");
                Modify;
            end;
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Name, Description)
        {
        }
    }

    trigger OnDelete()
    begin
        DIAJournalNameJournalLine.SetRange("Journal Template Name", "Journal Template Name");
        DIAJournalNameJournalLine.SetRange("Journal Batch Name", Name);
        DIAJournalNameJournalLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        LockTable;
        DIAJournalNameJournalTemplate.Get("Journal Template Name");
    end;

    trigger OnRename()
    begin
        DIAJournalNameJournalLine.SetRange("Journal Template Name", xRec."Journal Template Name");
        DIAJournalNameJournalLine.SetRange("Journal Batch Name", xRec.Name);
        while DIAJournalNameJournalLine.FindFirst do
            DIAJournalNameJournalLine.Rename("Journal Template Name", Name, DIAJournalNameJournalLine."Line No.");
    end;

    var
        DIAJournalNameJournalTemplate: Record DIAJournalNameJournalTemplate;
        DIAJournalNameJournalLine: Record DIAJournalNameJournalLine;
        Text001: Label 'must not be %1';

    procedure SetupNewJournalBatch()
    begin
        DIAJournalNameJournalTemplate.Get("Journal Template Name");
        "No. Series" := DIAJournalNameJournalTemplate."No. series";
        "Posting No. Series" := DIAJournalNameJournalTemplate."Posting No. series";
        "Reason Code" := DIAJournalNameJournalTemplate."Reason Code";
    end;
}

