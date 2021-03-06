# TODO: Fix Authlogic where it saves records with save(false). Use save(:validation => false) instead. Search for /save.*\(false\)/

module ActionController
  class IntegrationTest

  protected

    def login
      visit "/cms"
      page.execute_script "$('div#rich_cms_dock a.login').click()"
      fill_in_and_submit "#raccoon_tip", {:Email => "paul.engel@holder.nl", :Password => "testrichcms"}, "Login"
    end

    def logout
      find("#rich_cms_dock").click_link "Logout"
    end

    def hide_dock
      find("#rich_cms_dock").click_link "Hide"
    end

    def close_raccoontip
      find("#raccoontip").click_link "Close"
      assert !find("#raccoon_tip").visible?
    end

    def mark_content
      page.execute_script "$('div#rich_cms_dock a.mark').click()"
    end

    def edit_content(key)
      page.execute_script "$('.cms_content.marked[data-key=" + key + "]').click()"
      assert find("#raccoon_tip").visible?
    end

    def fill_in_and_submit(selector, with, submit)
      within "#{selector} fieldset.inputs" do
        with.each do |key, value|
          begin
            fill_in key.to_s, :with => value
          rescue Selenium::WebDriver::Error::ElementNotDisplayedError
            page.execute_script "var input = $('#{selector} [name=\"#{key}\"]');" +
                                "if (input.data('cleditor')) {" +
                                "  input.val('#{value}');" +
                                "  input.data('cleditor').updateFrame();" +
                                "}"
          end
        end
      end
      find(selector).find_button(submit).click
    end

  end
end