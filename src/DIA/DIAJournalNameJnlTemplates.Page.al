page 85040 DIAJournalNameJnlTemplates
{
    Caption = 'DIAJournalCaptionENU Journal Templates';
    PageType = List;
    SourceTable = DIAJournalNameJournalTemplate;

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
                field("No. series"; Rec."No. series")
                {
                }
                field("Posting No. series"; Rec."Posting No. series")
                {
                }
                field("Source Code"; Rec."Source Code")
                {
                }
                field("Reason Code"; Rec."Reason Code")
                {
                }
                field("Page ID"; Rec."Page ID")
                {
                    LookupPageID = Objects;
                    Visible = false;
                }
                field("Page Name"; Rec."Page Name")
                {
                    DrillDown = false;
                    Visible = false;
                }
                field("Test Report ID"; Rec."Test Report ID")
                {
                    LookupPageID = Objects;
                    Visible = false;
                }
                field("Test Report Name"; Rec."Test Report Name")
                {
                    DrillDown = false;
                    Visible = false;
                }
                field("Posting Report ID"; Rec."Posting Report ID")
                {
                    LookupPageID = Objects;
                    Visible = false;
                }
                field("Posting Report Name"; Rec."Posting Report Name")
                {
                    DrillDown = false;
                    Visible = false;
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
            group("Te&mplate")
            {
                Caption = 'Te&mplate';
                Image = Template;
                action(Batches)
                {
                    Caption = 'Batches';
                    Image = Description;
                    RunObject = Page DIAJournalNameJnlBatches;
                    RunPageLink = "Journal Template Name" = FIELD(Name);
                }
            }
        }
    }
}

