page 85003 PostedEXSExpenseSheetSubform
{
    Caption = 'Lines';
    Editable = false;
    PageType = ListPart;
    SourceTable = PostedEXSExpenseSheetLine;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
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
        area(processing)
        {
            group("&Line")
            {
                Caption = '&Line';
                Image = Line;
                action("C&omments")
                {
                    Caption = 'C&omments';
                    Image = ViewComments;
                    RunObject = Page "EXSExpenseSheetComment Sheet";
                    RunPageLink = "Table Name" = CONST(Line),
                                  "Document No." = FIELD("Document No."),
                                  "Document Line No." = FIELD("Line No.");
                }
            }
        }
    }
}

