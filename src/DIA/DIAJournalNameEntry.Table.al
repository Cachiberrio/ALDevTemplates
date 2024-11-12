table 85043 DIAJournalNameEntry
{
    Caption = 'DIAJournalCaptionENU Entry';
    DrillDownPageID = DIAJournalNameEntries;
    LookupPageID = DIAJournalNameEntries;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            TableRelation = DIAJournalNameJournalTemplate.Name;
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = DIAJournalNameJournalBatch.Name;
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(6; Description; Text[80])
        {
            Caption = 'Description';
        }
        field(7; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
        }
        field(18; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
        }
        field(19; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

