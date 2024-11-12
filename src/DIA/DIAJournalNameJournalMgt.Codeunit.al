codeunit 85040 DIAJournalNameJournalMgt
{
    Permissions = TableData "Res. Journal Template" = imd,
                  TableData "Res. Journal Batch" = imd;

    trigger OnRun()
    begin
    end;

    var
        Text000: Label 'DIAJournalCodeENU';
        Text001: Label 'DIAJournalDescriptionENU';
        Text004: Label 'DEFAULT';
        Text005: Label 'Default Journal';
        OldNoJournalNameJnl: Code[20];
        OpenFromBatch: Boolean;

    procedure SelectTemplate(PageID: Integer; var DIAJournalNameJournalLine: Record DIAJournalNameJournalLine; var SelectedJournal: Boolean)
    var
        DIAJournalNameJournalTemplate: Record DIAJournalNameJournalTemplate;
    begin
        SelectedJournal := true;

        DIAJournalNameJournalTemplate.Reset;
        DIAJournalNameJournalTemplate.SetRange("Page ID", PageID);

        case DIAJournalNameJournalTemplate.Count of
            0:
                begin
                    DIAJournalNameJournalTemplate.Init;
                    DIAJournalNameJournalTemplate.Name := Text000;
                    DIAJournalNameJournalTemplate.Description := Text001;
                    DIAJournalNameJournalTemplate.Validate("Page ID", PageID);
                    DIAJournalNameJournalTemplate.Insert;
                    Commit;
                end;
            1:
                DIAJournalNameJournalTemplate.FindFirst;
            else
                SelectedJournal := PAGE.RunModal(0, DIAJournalNameJournalTemplate) = ACTION::LookupOK;
        end;
        if SelectedJournal then begin
            DIAJournalNameJournalLine.FilterGroup := 2;
            DIAJournalNameJournalLine.SetRange("Journal Template Name", DIAJournalNameJournalTemplate.Name);
            DIAJournalNameJournalLine.FilterGroup := 0;
            if OpenFromBatch then begin
                DIAJournalNameJournalLine."Journal Template Name" := '';
                PAGE.Run(DIAJournalNameJournalTemplate."Page ID", DIAJournalNameJournalLine);
            end;
        end;
    end;

    procedure SelectTemplateFromBatch(var DIAJournalNameJournalBatch: Record DIAJournalNameJournalBatch)
    var
        DIAJournalNameJournalLine: Record DIAJournalNameJournalLine;
        DIAJournalNameJournalTemplate: Record DIAJournalNameJournalTemplate;
    begin
        OpenFromBatch := true;
        DIAJournalNameJournalTemplate.Get(DIAJournalNameJournalBatch."Journal Template Name");
        DIAJournalNameJournalTemplate.TestField("Page ID");
        DIAJournalNameJournalBatch.TestField(Name);

        DIAJournalNameJournalLine.FilterGroup := 2;
        DIAJournalNameJournalLine.SetRange("Journal Template Name", DIAJournalNameJournalTemplate.Name);
        DIAJournalNameJournalLine.FilterGroup := 0;

        DIAJournalNameJournalLine."Journal Template Name" := '';
        DIAJournalNameJournalLine."Journal Batch Name" := DIAJournalNameJournalBatch.Name;
        PAGE.Run(DIAJournalNameJournalTemplate."Page ID", DIAJournalNameJournalLine);
    end;

    procedure OpenJournal(var ActualBatch: Code[10]; var DIAJournalNameJournalLine: Record DIAJournalNameJournalLine)
    begin
        CheckJournalTemplate(DIAJournalNameJournalLine.GetRangeMax("Journal Template Name"), ActualBatch);
        DIAJournalNameJournalLine.FilterGroup := 2;
        DIAJournalNameJournalLine.SetRange("Journal Batch Name", ActualBatch);
        DIAJournalNameJournalLine.FilterGroup := 0;
    end;

    procedure OpenBatch(var DIAJournalNameJournalBatch: Record DIAJournalNameJournalBatch)
    var
        DIAJournalNameJournalTemplate: Record DIAJournalNameJournalTemplate;
        DIAJournalNameJournalLine: Record DIAJournalNameJournalLine;
        SelectedJournal: Boolean;
    begin
        if DIAJournalNameJournalBatch.GetFilter("Journal Template Name") <> '' then
            exit;
        DIAJournalNameJournalBatch.FilterGroup(2);
        if DIAJournalNameJournalBatch.GetFilter("Journal Template Name") <> '' then begin
            DIAJournalNameJournalBatch.FilterGroup(0);
            exit;
        end;
        DIAJournalNameJournalBatch.FilterGroup(0);

        if not DIAJournalNameJournalBatch.Find('-') then begin
            if not DIAJournalNameJournalTemplate.FindFirst then
                SelectTemplate(0, DIAJournalNameJournalLine, SelectedJournal);
            if DIAJournalNameJournalTemplate.FindFirst then
                CheckJournalTemplate(DIAJournalNameJournalTemplate.Name, DIAJournalNameJournalBatch.Name);
            SelectTemplate(0, DIAJournalNameJournalLine, SelectedJournal);
            if DIAJournalNameJournalTemplate.FindFirst then
                CheckJournalTemplate(DIAJournalNameJournalTemplate.Name, DIAJournalNameJournalBatch.Name);
        end;
        DIAJournalNameJournalBatch.Find('-');
        SelectedJournal := true;
        if DIAJournalNameJournalBatch.GetFilter("Journal Template Name") <> '' then
            DIAJournalNameJournalTemplate.SetRange(Name, DIAJournalNameJournalBatch.GetFilter("Journal Template Name"));
        case DIAJournalNameJournalTemplate.Count of
            1:
                DIAJournalNameJournalTemplate.FindFirst;
            else
                SelectedJournal := PAGE.RunModal(0, DIAJournalNameJournalTemplate) = ACTION::LookupOK;
        end;
        if not SelectedJournal then
            Error('');

        DIAJournalNameJournalBatch.FilterGroup(2);
        DIAJournalNameJournalBatch.SetRange("Journal Template Name", DIAJournalNameJournalTemplate.Name);
        DIAJournalNameJournalBatch.FilterGroup(0);
    end;

    procedure CheckJournalTemplate(ActualTemplate: Code[10]; var ActualBatch: Code[10])
    var
        DIAJournalNameJournalBatch: Record DIAJournalNameJournalBatch;
    begin
        DIAJournalNameJournalBatch.SetRange("Journal Template Name", ActualTemplate);
        if not DIAJournalNameJournalBatch.Get(ActualTemplate, ActualBatch) then begin
            if not DIAJournalNameJournalBatch.FindFirst then begin
                DIAJournalNameJournalBatch.Init;
                DIAJournalNameJournalBatch."Journal Template Name" := ActualTemplate;
                DIAJournalNameJournalBatch.SetupNewJournalBatch;
                DIAJournalNameJournalBatch.Name := Text004;
                DIAJournalNameJournalBatch.Description := Text005;
                DIAJournalNameJournalBatch.Insert(true);
                Commit;
            end;
            ActualBatch := DIAJournalNameJournalBatch.Name;
        end;
    end;

    procedure CheckName(ActualBatch: Code[10]; var DIAJournalNameJournalLine: Record DIAJournalNameJournalLine)
    var
        DIAJournalNameJournalBatch: Record DIAJournalNameJournalBatch;
    begin
        DIAJournalNameJournalBatch.Get(DIAJournalNameJournalLine.GetRangeMax("Journal Template Name"), ActualBatch);
    end;

    procedure SetName(ActualBatch: Code[10]; var DIAJournalNameJournalLine: Record DIAJournalNameJournalLine)
    begin
        DIAJournalNameJournalLine.FilterGroup := 2;
        DIAJournalNameJournalLine.SetRange("Journal Batch Name", ActualBatch);
        DIAJournalNameJournalLine.FilterGroup := 0;
        if DIAJournalNameJournalLine.Find('-') then;
    end;

    procedure LookupNombre(var ActualBatch: Code[10]; var DIAJournalNameJournalLine: Record DIAJournalNameJournalLine): Boolean
    var
        DIAJournalNameJournalBatch: Record DIAJournalNameJournalBatch;
    begin
        Commit;
        DIAJournalNameJournalBatch."Journal Template Name" := DIAJournalNameJournalLine.GetRangeMax("Journal Template Name");
        DIAJournalNameJournalBatch.Name := DIAJournalNameJournalLine.GetRangeMax("Journal Batch Name");
        DIAJournalNameJournalBatch.FilterGroup(2);
        DIAJournalNameJournalBatch.SetRange("Journal Template Name", DIAJournalNameJournalBatch."Journal Template Name");
        DIAJournalNameJournalBatch.FilterGroup(0);
        if PAGE.RunModal(0, DIAJournalNameJournalBatch) = ACTION::LookupOK then begin
            ActualBatch := DIAJournalNameJournalBatch.Name;
            SetName(ActualBatch, DIAJournalNameJournalLine);
        end;
    end;

    procedure GetJournal(NoJournalName: Code[20]; var NameJournalName: Text[50])
    var
        DIAJournalNameJournalTemplate: Record DIAJournalNameJournalTemplate;
    begin
        if NoJournalName <> OldNoJournalNameJnl then begin
            NameJournalName := '';
            if NoJournalName <> '' then
                if DIAJournalNameJournalTemplate.Get(NoJournalName) then
                    NameJournalName := DIAJournalNameJournalTemplate.Name;
            OldNoJournalNameJnl := NoJournalName;
        end;
    end;

    procedure PrintJournalBatch(DIAJournalNameJournalBatch: Record DIAJournalNameJournalBatch)
    var
        DIAJournalNameJournalTemplate: Record DIAJournalNameJournalTemplate;
    begin
        DIAJournalNameJournalBatch.SetRecFilter;
        DIAJournalNameJournalTemplate.Get(DIAJournalNameJournalBatch."Journal Template Name");
        DIAJournalNameJournalTemplate.TestField("Test Report ID");
        REPORT.Run(DIAJournalNameJournalTemplate."Test Report ID", true, false, DIAJournalNameJournalBatch);
    end;

    procedure PrintJournalLine(var DIAJournalNameJournalLine: Record DIAJournalNameJournalLine)
    var
        NewDIAJournalNameJournalLine: Record DIAJournalNameJournalLine;
        DIAJournalNameJournalTemplate: Record DIAJournalNameJournalTemplate;
    begin
        DIAJournalNameJournalLine.Copy(NewDIAJournalNameJournalLine);
        DIAJournalNameJournalLine.SetRange("Journal Template Name", DIAJournalNameJournalLine."Journal Template Name");
        DIAJournalNameJournalLine.SetRange("Journal Batch Name", DIAJournalNameJournalLine."Journal Batch Name");
        DIAJournalNameJournalTemplate.Get(DIAJournalNameJournalLine."Journal Template Name");
        DIAJournalNameJournalTemplate.TestField("Test Report ID");
        REPORT.Run(DIAJournalNameJournalTemplate."Test Report ID", true, false, DIAJournalNameJournalLine);
    end;

    [EventSubscriber(ObjectType::Page, 344, 'OnAfterFindRecords', '', false, false)]
    local procedure NavigateRelatedJournalNameEntries(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    begin
        FindJournalNameEntries(DocumentEntry, DocNoFilter, PostingDateFilter);
    end;

    local procedure FindJournalNameEntries(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    var
        DIAJournalNameEntry: Record DIAJournalNameEntry;
        DocType: Enum Microsoft.Foundation.Navigate."Document Entry Document Type";
    begin
        if DIAJournalNameEntry.ReadPermission then begin
            DIAJournalNameEntry.Reset;
            DIAJournalNameEntry.SetCurrentKey("Document No.", "Posting Date");
            DIAJournalNameEntry.SetFilter("Document No.", DocNoFilter);
            DIAJournalNameEntry.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(DocumentEntry, DATABASE::DIAJournalNameEntry, DocType, DIAJournalNameEntry.TableCaption, DIAJournalNameEntry.Count);
        end;
    end;

    local procedure InsertIntoDocEntry(var TempDocumentEntry: Record "Document Entry" temporary; DocTableID: Integer; DocType: Enum "Document Entry Document Type"; DocTableName: Text[1024]; DocNoOfRecords: Integer)
    begin
        if DocNoOfRecords = 0 then
            exit;
        TempDocumentEntry.Init;
        TempDocumentEntry."Entry No." := TempDocumentEntry."Entry No." + 1;
        TempDocumentEntry."Table ID" := DocTableID;
        TempDocumentEntry."Document Type" := DocType;
        TempDocumentEntry."Table Name" := CopyStr(DocTableName, 1, MaxStrLen(TempDocumentEntry."Table Name"));
        TempDocumentEntry."No. of Records" := DocNoOfRecords;
        TempDocumentEntry.Insert;
    end;
}

