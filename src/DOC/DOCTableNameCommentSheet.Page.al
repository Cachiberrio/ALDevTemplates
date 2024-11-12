page 85007 "DOCTableNameComment Sheet"
{
    AutoSplitKey = true;
    Caption = 'DOCTableCaptionENU Comment Sheet';
    DataCaptionFields = "Table Name", "Document No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = DOCTableNameCommentLine;

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

