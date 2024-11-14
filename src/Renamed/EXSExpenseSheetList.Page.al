page 85002 EXSExpenseSheetList
{
    Caption = 'Expense Sheet List';
    CardPageID = EXSExpenseSheet;
    Editable = false;
    PageType = List;
    SourceTable = EXSExpenseSheetHeader;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Created By User Id."; Rec."Created By User Id.")
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Comments)
            {
                Caption = 'Comments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "EXSExpenseSheetComment Sheet";
                RunPageLink = "Table Name" = CONST(Header),
                              "Document No." = FIELD("No.");
            }
        }
    }
}

