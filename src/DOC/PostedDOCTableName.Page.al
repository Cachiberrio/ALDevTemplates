page 85004 PostedDOCTableName
{
    Caption = 'Posted DOCTableCaptionENU';
    Editable = false;
    PageType = Document;
    SourceTable = PostedDOCTableNameHeader;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Created By User Id."; Rec."Created By User Id.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
            }
            part(Control1170170007; PostedDOCTableNameSubform)
            {
                SubPageLink = "Document No." = FIELD("No.");
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
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                var
                    PostedDOCTableNameHeader: Record PostedDOCTableNameHeader;
                    PostedDOCTableName: Report PostedDOCTableName;
                begin
                    PostedDOCTableNameHeader := Rec;
                    PostedDOCTableNameHeader.SetRecFilter;
                    Clear(PostedDOCTableName);
                    PostedDOCTableName.SetTableView(PostedDOCTableNameHeader);
                    PostedDOCTableName.Run;
                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Navigate();
                end;
            }
        }
    }
}

