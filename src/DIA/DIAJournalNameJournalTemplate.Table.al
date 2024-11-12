table 85040 DIAJournalNameJournalTemplate
{
    // DIA Cadenas a sustituir
    // =================================
    // DIAJournalName
    // DIAJournalCode
    // DIAJournalCaptionENU
    // DIAJournalCaptionESP

    Caption = 'DIAJournalCaptionENU Journal Template';
    DrillDownPageID = DIAJournalNameJnlTempList;
    LookupPageID = DIAJournalNameJnlTempList;

    fields
    {
        field(1; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(2; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(3; "Page ID"; Integer)
        {
            Caption = 'Page ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Page));
        }
        field(4; "Page Name"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Page),
                                                                           "Object ID" = FIELD("Page ID")));
            Caption = 'Page Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "No. series"; Code[20])
        {
            Caption = 'No. series';
            TableRelation = "No. Series".Code;

            trigger OnValidate()
            begin
                if "No. series" <> '' then begin
                    if "No. series" = "Posting No. series" then
                        "Posting No. series" := '';
                end;
            end;
        }
        field(6; "Posting No. series"; Code[20])
        {
            Caption = 'Posting No. series';
            TableRelation = "No. Series".Code;

            trigger OnValidate()
            begin
                if ("Posting No. series" = "No. series") and ("Posting No. series" <> '') then
                    FieldError("Posting No. series", StrSubstNo(Text001, "Posting No. series"));
            end;
        }
        field(8; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";

            trigger OnValidate()
            begin
                DIAJournalNameJournalLine.SetRange("Journal Template Name", Name);
                DIAJournalNameJournalLine.ModifyAll("Source Code", "Source Code");
                Modify;
            end;
        }
        field(9; "Test Report ID"; Integer)
        {
            Caption = 'Test Report ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(10; "Posting Report ID"; Integer)
        {
            Caption = 'Posting Report ID';
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));
        }
        field(11; "Test Report Name"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                           "Object ID" = FIELD("Test Report ID")));
            Caption = 'Test Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; "Posting Report Name"; Text[250])
        {
            CalcFormula = Lookup(AllObjWithCaption."Object Caption" WHERE("Object Type" = CONST(Report),
                                                                           "Object ID" = FIELD("Posting Report ID")));
            Caption = 'Posting Report Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
    }

    keys
    {
        key(Key1; Name)
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
        DIAJournalNameJournalLine.SetRange("Journal Template Name", Name);
        DIAJournalNameJournalLine.DeleteAll(true);
        DIAJournalNameJournalBatch.SetRange("Journal Template Name", Name);
        DIAJournalNameJournalBatch.DeleteAll;
    end;

    trigger OnInsert()
    begin
        Validate("Page ID");
    end;

    var
        DIAJournalNameJournalBatch: Record DIAJournalNameJournalBatch;
        DIAJournalNameJournalLine: Record DIAJournalNameJournalLine;
        Text001: Label 'must not be %1';
}

