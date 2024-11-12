page 85020 CODPageName
{
    Caption = 'PageCaptionENU';
    Editable = true;
    PageType = List;
    SourceTable = CODTableName;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
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
    }
}

