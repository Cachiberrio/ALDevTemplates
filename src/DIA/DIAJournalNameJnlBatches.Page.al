page 85043 DIAJournalNameJnlBatches
{
    Caption = 'DIAJournalCaptionENU Journal Batches';
    DataCaptionExpression = DataCaption;
    PageType = List;
    SourceTable = DIAJournalNameJournalBatch;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field(Name; Rec.Name)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("No. Series"; Rec."No. Series")
                {
                }
                field("Posting No. Series"; Rec."Posting No. Series")
                {
                }
                field("Reason Code"; Rec."Reason Code")
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
        area(processing)
        {
            action("Edit Journal")
            {
                Caption = 'Edit Journal';
                Image = OpenJournal;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Return';

                trigger OnAction()
                begin
                    JournalNameJournalMgt.SelectTemplateFromBatch(Rec);
                end;
            }
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
                        ReportPrint.PrintJournalBatch(Rec);
                    end;
                }
                action(Post)
                {
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Res. Jnl.-B.Post";
                    ShortCutKey = 'F9';
                }
                action(PostAndPrint)
                {
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Codeunit "Res. Jnl.-B.Post+Print";
                    ShortCutKey = 'Shift+F9';
                }
            }
        }
    }

    trigger OnInit()
    begin
        Rec.SetRange("Journal Template Name");
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewJournalBatch();
    end;

    trigger OnOpenPage()
    begin
        JournalNameJournalMgt.OpenBatch(Rec);
    end;

    var
        JournalNameJournalMgt: Codeunit DIAJournalNameJournalMgt;

    local procedure DataCaption(): Text[250]
    var
        DIAJournalNameJournalTemplate: Record DIAJournalNameJournalTemplate;
    begin
        if not CurrPage.LookupMode then
            if Rec.GetFilter("Journal Template Name") <> '' then
                if Rec.GetRangeMin("Journal Template Name") = Rec.GetRangeMax("Journal Template Name") then
                    if DIAJournalNameJournalTemplate.Get(Rec.GetRangeMin("Journal Template Name")) then
                        exit(DIAJournalNameJournalTemplate.Name + ' ' + DIAJournalNameJournalTemplate.Description);
    end;
}

