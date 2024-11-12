page 85000 DOCTableNameLineSubform
{
    AutoSplitKey = true;
    Caption = 'DOCTableCaptionENU Lines Subform';
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = DOCTableNameLine;

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
                    RunObject = Page "DOCTableNameComment Sheet";
                    RunPageLink = "Table Name" = CONST(Line),
                                  "Document No." = FIELD("Document No."),
                                  "Document Line No." = FIELD("Line No.");
                }
            }
        }
    }
}

