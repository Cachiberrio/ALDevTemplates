page 85007 "EXSExpenseSheetComment Sheet"
{
    AutoSplitKey = true;
    Caption = 'Expense Sheet Comment Sheet';
    DataCaptionFields = "Table Name", "Document No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = EXSExpenseSheetCommentLine;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Date; Rec.Date)
                {
                }
                field(Comment; Rec.Comment)
                {
                }
                field("Code"; Rec.Code)
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewLine();
    end;
}

