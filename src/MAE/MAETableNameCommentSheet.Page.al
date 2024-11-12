page 85072 MAETableNameCommentSheet
{
    AutoSplitKey = true;
    Caption = 'MAETableCaptionENU Comment Sheet';
    DataCaptionFields = "Table Name", "MAETableName No.";
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = MAETableNameCommentLine;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    Visible = false;
                }
                field(Date; Rec.Date)
                {
                }
                field(Comment; Rec.Comment)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetupNewLine;
    end;
}

