小说下载器

[站点]

绿晋江 http://www.jjwxc.net
豆豆小说网 http://www.dddbbb.net


[用法]

1、下载小说，存成txt/html：
get_book_to_txt.pl http://www.dddbbb.net/html/18451/index.html 
get_book_to_html.pl http://www.dddbbb.net/html/18451/index.html 

2、下载小说，导入wordpress空间：
get_book_to_wordpress.pl -b http://www.dddbbb.net/html/18451/index.html -c 言情 -w http://xxx.xxx.com  -u xxx -p xxx

3、取出小说 目录页/章节页/作者页/查询关键字 信息，以JSON格式输出：
get_index_to_json.pl http://www.jjwxc.net/onebook.php?novelid=2456
get_chapter_to_json.pl "http://www.jjwxc.net/onebook.php?novelid=2456&chapterid=2" 2
get_writer_to_json.pl http://www.jjwxc.net/oneauthor.php?authorid=3243
get_query_to_json.pl Jjwxc 作者 顾漫

5、批量处理小说(支持to txt/html/wordpress ...)
get_books_to_any.pl -w http://www.jjwxc.net/oneauthor.php?authorid=6 -m 1 -t "perl get_book_to_html.pl {url}"
