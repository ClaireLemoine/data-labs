use pulications;

select a.au_id as 'AUTHOR ID', a.au_lname as 'LAST NAME', a.au_fname as 'FIRST NAME',  round(t.price * t.ytd_sales * (t.royalty/100) + t.advance) as 'PROFIT'
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join sales s on ta.title_id=s.title_id
inner join titles t on ta.title_id=t.title_id
group by a.au_id
order by PROFIT desc;

# Step 1: Calculate the royalties of each sales for each author

SELECT t.title_id as 'TITLE ID', a.au_id as 'AUTHOR ID', (t.price * s.qty * ta.royaltyper / 100 * t.royalty / 100) as 'ROYALTY PER SALE'
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join sales s on ta.title_id=s.title_id
inner join titles t on ta.title_id=t.title_id;

# Step 2: Aggregate the total royalties for each title for each author

SELECT TITLE_ID, AUTHOR_ID, sum(RPS) as AGG_ROYALTIES
from(
SELECT t.title_id as TITLE_ID, a.au_id as AUTHOR_ID, (t.price * s.qty * ta.royaltyper / 100 * t.royalty / 100) as RPS
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join sales s on ta.title_id=s.title_id
inner join titles t on ta.title_id=t.title_id) as nt
group by AUTHOR_ID, TITLE_ID;

# Step 3: Calculate the total profits of each author

SELECT a.au_id as AUTHOR_ID, sum(RPS)+(t.advance*ta.royaltyper) as TOTAL_PROFIT
from titles t
inner join titleauthor ta on t.title_id =ta.title_id
from(
SELECT t.title_id as TITLE_ID, a.au_id, (t.price * s.qty * ta.royaltyper / 100 * t.royalty / 100) as 'RPS'
from authors a
inner join titleauthor ta on a.au_id=ta.au_id
inner join sales s on ta.title_id=s.title_id
inner join titles t on ta.title_id=t.title_id) as nt
order by TOTAL_PROFIT desc limit 3;