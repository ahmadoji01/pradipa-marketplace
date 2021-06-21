require "application_system_test_case"

class Spree::BlogsTest < ApplicationSystemTestCase
  setup do
    @spree_blog = spree_blogs(:one)
  end

  test "visiting the index" do
    visit spree_blogs_url
    assert_selector "h1", text: "Spree/Blogs"
  end

  test "creating a Blog" do
    visit spree_blogs_url
    click_on "New Spree/Blog"

    fill_in "Body", with: @spree_blog.body
    fill_in "Category", with: @spree_blog.category
    fill_in "Edited at", with: @spree_blog.edited_at
    fill_in "Featured image", with: @spree_blog.featured_image
    fill_in "Meta keyword", with: @spree_blog.meta_keyword
    fill_in "Meta title", with: @spree_blog.meta_title
    fill_in "Subtitle", with: @spree_blog.subtitle
    fill_in "Title", with: @spree_blog.title
    click_on "Create Blog"

    assert_text "Blog was successfully created"
    click_on "Back"
  end

  test "updating a Blog" do
    visit spree_blogs_url
    click_on "Edit", match: :first

    fill_in "Body", with: @spree_blog.body
    fill_in "Category", with: @spree_blog.category
    fill_in "Edited at", with: @spree_blog.edited_at
    fill_in "Featured image", with: @spree_blog.featured_image
    fill_in "Meta keyword", with: @spree_blog.meta_keyword
    fill_in "Meta title", with: @spree_blog.meta_title
    fill_in "Subtitle", with: @spree_blog.subtitle
    fill_in "Title", with: @spree_blog.title
    click_on "Update Blog"

    assert_text "Blog was successfully updated"
    click_on "Back"
  end

  test "destroying a Blog" do
    visit spree_blogs_url
    page.accept_confirm do
      click_on "Destroy", match: :first
    end

    assert_text "Blog was successfully destroyed"
  end
end
