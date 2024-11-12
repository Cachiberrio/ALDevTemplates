page 85006 DOCTableNameSetup
{
    Caption = 'DOCTableCaptionENU Sertup';
    PageType = Card;
    SourceTable = DOCTableNameSetup;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("DOCTableCaptionENU No. Series"; Rec."DOCTableCaptionENU No. Series")
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}

