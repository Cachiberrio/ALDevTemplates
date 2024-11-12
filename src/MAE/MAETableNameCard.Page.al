page 85070 MAETableNameCard
{
    Caption = 'MAETableCaptionENU Card';
    PageType = Document;
    SourceTable = MAETableName;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {

                    trigger OnAssistEdit()
                    begin
                        Rec.AssistEdit(Rec);
                    end;
                }
                field(Description; Rec.Description)
                {
                }
                field("Created By User Id."; Rec."Created By User Id.")
                {
                }
                field(Date; Rec.Date)
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

