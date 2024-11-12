page 85071 MAETableNameList
{
    Caption = 'MAETableCaptionENU List';
    CardPageID = MAETableNameCard;
    Editable = false;
    PageType = List;
    SourceTable = MAETableName;

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
                PromotedOnly = true;
                RunObject = Page MAETableNameCommentSheet;
                RunPageLink = "Table Name" = CONST(MAETableName),
                              "MAETableName No." = FIELD("No.");
            }
        }
    }
}

