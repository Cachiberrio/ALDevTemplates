page 85041 DIAJournalNameJournal
{
    AutoSplitKey = true;
    Caption = 'DIAJournalCaptionENU Journal';
    DataCaptionFields = "Journal Template Name", "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = DIAJournalNameJournalLine;

    layout
    {
        area(content)
        {
            field(ActualJournalBatch; ActualJournalBatch)
            {
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    DIAJournalNameJournalMgt.LookupNombre(ActualJournalBatch, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    DIAJournalNameJournalMgt.CheckName(ActualJournalBatch, Rec);
                end;
            }
            repeater(Control1)
            {
                ShowCaption = false;
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(TestReport)
                {
                    Caption = 'Test Report';
                    Ellipsis = true;
                    Image = TestReport;

                    trigger OnAction()
                    var
                        ReportPrint: Codeunit DIAJournalNameJournalMgt;
                    begin
                        ReportPrint.PrintJournalLine(Rec);
                    end;
                }
                action(Post)
                {
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::DIAJournalNameJournalPost, Rec);
                        ActualJournalBatch := Rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action(PostAndPrint)
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::DIAJournalNameJnlPostPrint, Rec);
                        ActualJournalBatch := Rec.GetRangeMax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewLine(xRec);
    end;

    trigger OnOpenPage()
    var
        DiarioSeleccionado: Boolean;
    begin
        OpenFromJournalBatch := (Rec."Journal Batch Name" <> '') and (Rec."Journal Template Name" = '');
        if OpenFromJournalBatch then begin
            ActualJournalBatch := Rec."Journal Batch Name";
            DIAJournalNameJournalMgt.OpenJournal(ActualJournalBatch, Rec);
            exit;
        end;
        DIAJournalNameJournalMgt.SelectTemplate(PAGE::DIAJournalNameJournal, Rec, DiarioSeleccionado);
        if not DiarioSeleccionado then
            Error('');
        DIAJournalNameJournalMgt.OpenJournal(ActualJournalBatch, Rec);
    end;

    var
        DIAJournalNameJournalMgt: Codeunit DIAJournalNameJournalMgt;
        ActualJournalBatch: Code[10];
        OpenFromJournalBatch: Boolean;
}

