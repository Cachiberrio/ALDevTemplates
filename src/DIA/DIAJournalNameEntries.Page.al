page 85044 DIAJournalNameEntries
{
    Caption = 'DIAJournalCaptionENU Entries';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = DIAJournalNameEntry;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document No."; Rec."Document No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Source Code"; Rec."Source Code")
                {
                    Visible = false;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    Editable = false;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Print)
            {
                Caption = 'Print';
                Image = Print;

                trigger OnAction()
                begin
                    Clear(DIAJournalNameEntries);
                    DIAJournalNameEntries.SetTableView(Rec);
                    DIAJournalNameEntries.Run;
                end;
            }
            action(Navigate)
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category5;
                Scope = Repeater;
                ToolTip = 'Find all entries and documents that exist for the document number and posting date on the selected entry or document.';

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }
        }
    }

    var
        DIAJournalNameEntries: Report DIAJournalNameEntries;
        Navigate: Page Navigate;
}

