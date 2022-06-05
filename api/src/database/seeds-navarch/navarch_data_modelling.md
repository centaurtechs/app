# Best Practices Applied

- Naming conventions: Naming convention of choice selected is snake_case. The most important thing is to be consistent
  in all the fields.
- Avoid using reserved words in table names, column names, fields, and so on, as this will almost certainly result in a
  syntax error.
- Use of hyphens, quotes, spaces, special characters, and so on will result in invalid results or will necessitate an
  additional step.
- For table names, use singular nouns rather than plural nouns (i.e. use StudentName instead of StudentNames). Because
  the table represents a collection, the title does not need to be plural.
- Remove unnecessary wordings from table names (for example, Department instead of DepartmentList, TableDepartments,
  etc).
- Security: Data security begins with a well-designed database schema. For sensitive data, such as personally
  identifiable information (PII) and passwords, use encryption. Instead of assigning administrator roles to each user,
  request user authentication for database access.
- Documentation: Database schemas are useful long after they are created, and they will be viewed by many other people,
  so good documentation is essential. Document the design of your database schema with explicit instructions, and
  include comment lines for scripts, triggers, and so on.
- Normalization: In a nutshell, normalization ensures that independent entities and relationships are not grouped
  together in the same table, which reduces redundancy and improves integrity. Use normalization as needed to improve
  database performance. Over-normalization and under-normalization can both lead to poor performance.
- Expertise: Well understanding and recognizing your data and the attributes of each element aid in the development of
  the most effective database schema design. A well-designed schema can allow your data to grow at an exponential rate.
  As you continue to collect data, you can analyze each field in relation to the others in your schema.
