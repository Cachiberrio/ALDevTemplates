codeunit 85043 DIAJournalNameJnlPostBatch
{
    TableNo = DIAJournalNameJournalLine;

    trigger OnRun()
    begin
        DIAJournalNameJournalLine.Copy(Rec);
        Code;
        Rec := DIAJournalNameJournalLine;
    end;

    var
        Text000: Label 'cannot exceed %1 characters';
        Text001: Label 'Journal Batch Name    #1##########\\';
        Text002: Label 'Checking lines        #2######\';
        Text003: Label 'Posting lines         #3###### @4@@@@@@@@@@@@@\';
        Text004: Label 'Updating lines        #5###### @6@@@@@@@@@@@@@';
        Text005: Label 'Posting lines         #3###### @4@@@@@@@@@@@@@';
        Text006: Label 'A maximum of %1 posting number series can be used in each journal.';
        DIAJournalNameJournalTemplate: Record DIAJournalNameJournalTemplate;
        DIAJournalNameJournalBatch: Record DIAJournalNameJournalBatch;
        DIAJournalNameJournalLine: Record DIAJournalNameJournalLine;
        DIAJournalNameJournalLine2: Record DIAJournalNameJournalLine;
        DIAJournalNameJournalLine3: Record DIAJournalNameJournalLine;
        DIAJournalNameEntry: Record DIAJournalNameEntry;
        DIAJournalNameJnlCheckLine: Codeunit DIAJournalNameJnlCheckLine;
        DIAJournalNameJnlPostLine: Codeunit DIAJournalNameJnlPostLine;
        NoSeries: Record "No. Series" temporary;
        NoSeriesMgt2: array[10] of Codeunit "No. Series";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        NoSeriesBatch2: array[10] of Codeunit "No. Series - Batch";
        Window: Dialog;
        StartLineNo: Integer;
        LineCount: Integer;
        NoOfRecords: Integer;
        LastDocNo: Code[20];
        LastDocNo2: Code[20];
        LastPostedDocNo: Code[20];
        NoOfPostingNoSeries: Integer;
        PostingNoSeriesNo: Integer;

    local procedure "Code"()
    begin
        DIAJournalNameJournalLine.LockTable;
        DIAJournalNameJournalLine.SetRange("Journal Template Name", DIAJournalNameJournalLine."Journal Template Name");
        DIAJournalNameJournalLine.SetRange("Journal Batch Name", DIAJournalNameJournalLine."Journal Batch Name");

        DIAJournalNameJournalTemplate.Get(DIAJournalNameJournalLine."Journal Template Name");
        DIAJournalNameJournalBatch.Get(DIAJournalNameJournalLine."Journal Template Name", DIAJournalNameJournalLine."Journal Batch Name");
        if StrLen(IncStr(DIAJournalNameJournalBatch.Name)) > MaxStrLen(DIAJournalNameJournalBatch.Name) then
            DIAJournalNameJournalBatch.FieldError(
              Name,
              StrSubstNo(
                Text000,
                MaxStrLen(DIAJournalNameJournalBatch.Name)));

        if not DIAJournalNameJournalLine.Find('=><') then begin
            DIAJournalNameJournalLine."Line No." := 0;
            Commit;
            exit;
        end;

        Window.Open(
          Text001 +
          Text002 +
          Text005);
        Window.Update(1, DIAJournalNameJournalLine."Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := DIAJournalNameJournalLine."Line No.";
        repeat
            LineCount := LineCount + 1;
            Window.Update(2, LineCount);
            DIAJournalNameJnlCheckLine.RunCheck(DIAJournalNameJournalLine);
            if DIAJournalNameJournalLine.Next = 0 then
                DIAJournalNameJournalLine.Find('-');
        until DIAJournalNameJournalLine."Line No." = StartLineNo;
        NoOfRecords := LineCount;

        // Find next register no.
        DIAJournalNameEntry.LockTable;
        if DIAJournalNameEntry.Find('+') then;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        DIAJournalNameJournalLine.FindSet;
        repeat
            LineCount := LineCount + 1;
            Window.Update(3, LineCount);
            Window.Update(4, Round(LineCount / NoOfRecords * 10000, 1));
            if not DIAJournalNameJournalLine.EmptyLine() and
               (DIAJournalNameJournalBatch."No. Series" <> '') and
               (DIAJournalNameJournalLine."Document No." <> LastDocNo2)
            then
                DIAJournalNameJournalLine.TestField("Document No.", NoSeriesBatch.GetNextNo(DIAJournalNameJournalBatch."No. Series", DIAJournalNameJournalLine."Posting Date", false));
            if not DIAJournalNameJournalLine.EmptyLine() then
                LastDocNo2 := DIAJournalNameJournalLine."Document No.";
            if DIAJournalNameJournalLine."Posting No. Series" = '' then
                DIAJournalNameJournalLine."Posting No. Series" := DIAJournalNameJournalBatch."No. Series"
            else
                if not DIAJournalNameJournalLine.EmptyLine() then
                    if (DIAJournalNameJournalLine."Document No." = LastDocNo) and (DIAJournalNameJournalLine."Document No." <> '') then
                        DIAJournalNameJournalLine."Document No." := LastPostedDocNo
                    else begin
                        if not NoSeries.Get(DIAJournalNameJournalLine."Posting No. Series") then begin
                            NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                            if NoOfPostingNoSeries > ArrayLen(NoSeriesBatch2) then
                                Error(
                                  Text006,
                                  ArrayLen(NoSeriesBatch2));
                            NoSeries.Code := DIAJournalNameJournalLine."Posting No. Series";
                            NoSeries.Description := Format(NoOfPostingNoSeries);
                            NoSeries.Insert;
                        end;
                        LastDocNo := DIAJournalNameJournalLine."Document No.";
                        Evaluate(PostingNoSeriesNo, NoSeries.Description);
                        DIAJournalNameJournalLine."Document No." := NoSeriesBatch2[PostingNoSeriesNo].GetNextNo(DIAJournalNameJournalLine."Posting No. Series", DIAJournalNameJournalLine."Posting Date", false);
                        LastPostedDocNo := DIAJournalNameJournalLine."Document No.";
                    end;
            DIAJournalNameJnlPostLine.RunWithCheck(DIAJournalNameJournalLine);
        until DIAJournalNameJournalLine.Next = 0;

        DIAJournalNameJournalLine.Init;

        // Update/delete lines
        DIAJournalNameJournalLine2.CopyFilters(DIAJournalNameJournalLine);
        if DIAJournalNameJournalLine2.Find('+') then; // Remember the last line
        DIAJournalNameJournalLine3.Copy(DIAJournalNameJournalLine);
        DIAJournalNameJournalLine3.DeleteAll;
        DIAJournalNameJournalLine3.Reset;
        DIAJournalNameJournalLine3.SetRange("Journal Template Name", DIAJournalNameJournalLine."Journal Template Name");
        DIAJournalNameJournalLine3.SetRange("Journal Batch Name", DIAJournalNameJournalLine."Journal Batch Name");
        if not DIAJournalNameJournalLine3.FindLast then
            if IncStr(DIAJournalNameJournalLine."Journal Batch Name") <> '' then begin
                DIAJournalNameJournalBatch.Delete;
                DIAJournalNameJournalBatch.Name := IncStr(DIAJournalNameJournalLine."Journal Batch Name");
                if DIAJournalNameJournalBatch.Insert then;
                DIAJournalNameJournalLine."Journal Batch Name" := DIAJournalNameJournalBatch.Name;
            end;

        DIAJournalNameJournalLine3.SetRange("Journal Batch Name", DIAJournalNameJournalLine."Journal Batch Name");
        if (DIAJournalNameJournalBatch."No. Series" = '') and not DIAJournalNameJournalLine3.FindLast then begin
            DIAJournalNameJournalLine3.Init;
            DIAJournalNameJournalLine3."Journal Template Name" := DIAJournalNameJournalLine."Journal Template Name";
            DIAJournalNameJournalLine3."Journal Batch Name" := DIAJournalNameJournalLine."Journal Batch Name";
            DIAJournalNameJournalLine3."Line No." := 10000;
            DIAJournalNameJournalLine3.Insert;
            DIAJournalNameJournalLine3.SetupNewLine(DIAJournalNameJournalLine2);
            DIAJournalNameJournalLine3.Modify;
        end;
        if DIAJournalNameJournalBatch."No. Series" <> '' then
            NoSeriesBatch.SaveState();
        if NoSeries.Find('-') then
            repeat
                Evaluate(PostingNoSeriesNo, NoSeries.Description);
                NoSeriesBatch2[PostingNoSeriesNo].SaveState();
            until NoSeries.Next = 0;

        Commit;
        Commit;
    end;
}

