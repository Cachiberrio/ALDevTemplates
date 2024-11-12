page 85042 DIAJournalNameJnlTempList
{
    Caption = 'DIAJournalCaptionENU Journal Template List';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
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
                field("Source Code"; Rec."Source Code")
                {
                    Visible = false;
                }
                field("Reason Code"; Rec."Reason Code")
                {
                    Visible = false;
                }
                field("Page ID"; Rec."Page ID")
                {
                    LookupPageID = Objects;
                    Visible = false;
                }
                field("Test Report ID"; Rec."Test Report ID")
                {
                    LookupPageID = Objects;
                    Visible = false;
                }
                field("Posting Report ID"; Rec."Posting Report ID")
                {
                    LookupPageID = Objects;
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
    }
}

