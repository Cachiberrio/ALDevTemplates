table 85042 DIAJournalNameJournalLine
{
    Caption = 'DIAJournalCaptionENU Journal Line';
    DrillDownPageID = DIAJournalNameJournal;
    LookupPageID = DIAJournalNameJournal;

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = DIAJournalNameJournalTemplate.Name;
        }
        field(2; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = DIAJournalNameJournalBatch.Name WHERE("Journal Template Name" = FIELD("Journal Template Name"));
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
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
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        DIAJournalNameJournalTemplate: Record DIAJournalNameJournalTemplate;
        DIAJournalNameJournalBatch: Record DIAJournalNameJournalBatch;
        DIAJournalNameJournalLine: Record DIAJournalNameJournalLine;
        NoSeriesMgt: Codeunit "No. Series";

    procedure SetupNewLine(LastDIAJournalNameJournalLine: Record DIAJournalNameJournalLine)
    begin
        DIAJournalNameJournalTemplate.Get("Journal Template Name");
        DIAJournalNameJournalBatch.Get("Journal Template Name", "Journal Batch Name");
        DIAJournalNameJournalLine.SetRange("Journal Template Name", "Journal Template Name");
        DIAJournalNameJournalLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if DIAJournalNameJournalLine.FindFirst then begin
            "Posting Date" := LastDIAJournalNameJournalLine."Posting Date";
            "Document No." := LastDIAJournalNameJournalLine."Document No.";
        end else begin
            "Posting Date" := WorkDate;
            if DIAJournalNameJournalBatch."No. Series" <> '' then begin
                Clear(NoSeriesMgt);
                "Document No." := NoSeriesMgt.PeekNextNo(DIAJournalNameJournalBatch."No. Series", "Posting Date");
            end;
        end;
        "Source Code" := DIAJournalNameJournalTemplate."Source Code";
        "Reason Code" := DIAJournalNameJournalBatch."Reason Code";
        "Posting No. Series" := DIAJournalNameJournalBatch."Posting No. Series";
    end;

    procedure EmptyLine(): Boolean
    begin
    end;
}

