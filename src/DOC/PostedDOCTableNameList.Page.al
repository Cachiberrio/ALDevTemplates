page 85005 PostedDOCTableNameList
{
    Caption = 'Posted DOCTableCaptionENU List';
    CardPageID = PostedDOCTableName;
    Editable = false;
    PageType = List;
    SourceTable = PostedDOCTableNameHeader;

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
                RunObject = Page "DOCTableNameComment Sheet";
                RunPageLink = "Table Name" = CONST(Header),
                              "Document No." = FIELD("No.");
            }
        }
    }
}

