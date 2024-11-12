page 85001 DOCTableName
{
    Caption = 'DOCTableCaptionENU';
    PageType = Document;
    SourceTable = DOCTableNameHeader;

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
                field("Posting Date"; Rec."Posting Date")
                {
                }
            }
            part(Lines; DOCTableNameLineSubform)
            {
                Caption = 'Lines';
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
        }
        area(processing)
        {
            action("&Print")
            {
                Caption = '&Print';
                Ellipsis = true;
                Image = Print;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                var
                    DocumentNameHeader: Record DOCTableNameHeader;
                    DocumentName: Report DOCTableName;
                begin
                    DocumentNameHeader := Rec;
                    DocumentNameHeader.SetRecFilter;
                    Clear(DocumentName);
                    DocumentName.SetTableView(DocumentNameHeader);
                    DocumentName.Run;
                end;
            }
            group("P&osting")
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    Caption = 'P&ost';
                    Ellipsis = true;
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        CODEUNIT.Run(CODEUNIT::PostDOCTableNameYesNo, Rec);
                    end;
                }
            }
        }
    }
}

