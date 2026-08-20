# Guía de Uso de Git y GitHub

Empezaremos con una breve introducción a Git y GitHub, dos herramientas importantes para el control de versiones y la colaboración en proyectos de desarrollo de software y/o codificación en general.

## ¿Qué es Git?

Git es un sistema de control de versiones distribuido que permite a los desarrolladores rastrear cambios en su código fuente a lo largo del tiempo. Con Git, puedes:

- Guardar versiones de tu código. Versiones anteriores de tu proyecto pueden ser recuperadas en cualquier momento, lo que facilita la gestión de cambios y la colaboración entre varios desarrolladores.

- Colaborar con otros desarrolladores de manera eficiente. Eficiente para proyectos de cualquier tamaño, desde pequeños scripts hasta grandes aplicaciones. Con Git, los desarrolladores pueden trabajar en paralelo, fusionar cambios y resolver conflictos de manera efectiva.

- Revertir cambios si algo sale mal. Algo importante a destacar es que Git es un sistema distribuido, lo que significa que cada desarrollador tiene una copia completa del repositorio en su máquina local, lo que permite trabajar sin conexión y realizar cambios de manera independiente.

## ¿Qué es GitHub?

GitHub es una plataforma de alojamiento de código fuente basada en la web que utiliza Git como sistema de control de versiones. GitHub permite a los desarrolladores almacenar sus proyectos en línea, colaborar con otros y compartir su trabajo con la comunidad. Algunas características clave de GitHub incluyen:

- Repositorios: Un repositorio es un espacio donde se almacena el código fuente de un proyecto. En GitHub, puedes crear repositorios públicos o privados para organizar y gestionar tu código.

- Colaboración: GitHub facilita la colaboración entre desarrolladores mediante herramientas como pull requests, issues y wikis. Los pull requests permiten a los desarrolladores proponer cambios en un proyecto y discutirlos antes de fusionarlos.

    Dado que GitHub es una plataforma social, los desarrolladores pueden seguir a otros usuarios, ver sus contribuciones y participar en proyectos de código abierto. Así también, descargar y contribuir a proyectos existentes lo que contribuye al aprendizaje y la mejora de habilidades de programación o por mero interés en la codificación.

- Integración continua: GitHub se integra con diversas herramientas de integración continua y despliegue, lo que permite automatizar pruebas, compilaciones y despliegues de manera eficiente.

## Trabajo con ramas (branches) en Git y GitHub

Para trabajar con ramas en Git y GitHub, es importante entender que hacer siempre para comenzar a trabajar en una nueva característica o corrección de errores, es recomendable crear una nueva rama a partir de la rama principal (main o master).

1. Crear una nueva rama: Para crear una nueva rama, puedes usar el comando `git branch <nombre_rama>`. Esto va a crear una nueva rama con el nombre especificado.

2. Cambiar a la nueva rama: Para cambiar a la nueva rama, puedes usar el comando `git checkout <nombre_rama>` y ver todas las ramas existentes con `git branch -a`.  

3. Realizar cambios y confirmarlos: Una vez que estés en la nueva rama, puedes realizar cambios en tu código y confirmarlos con `git add <archivo>` y `git commit -m "mensaje"`.

4. Fusionar la rama con la rama principal: Cuando hayas terminado de trabajar en tu nueva característica o corrección de errores, puedes fusionar la rama con la rama principal usando el comando `git merge <nombre_rama>`. Finalmente, esto integrará los cambios realizados en la nueva rama en la rama principal.

5. Subir los cambios al repositorio remoto: Para subir los cambios al repositorio remoto en GitHub, puedes usar el comando `git push origin <nombre_rama>`. Esto enviará los cambios realizados en la nueva rama al repositorio remoto, permitiendo que otros colaboradores accedan a ellos.

6. Eliminar la rama local y remota: Una vez que la rama ha sido fusionada y los cambios han sido subidos al repositorio remoto, puedes eliminar la rama local con `git branch -d <nombre_rama>` y la rama remota con `git push origin --delete <nombre_rama>`. Es importante eliminar las ramas obsoletas para mantener el repositorio limpio y organizado, evitando confusiones con ramas obsoletas o innecesarias.

## Algunos comandos de Git

Los más usados a la hora de contribuir con un repositorio de GitHub son los siguientes:

- `git init`: Inicializa un nuevo repositorio de Git en tu proyecto.

- `git clone <url>`: Clona un repositorio existente desde GitHub a tu máquina local.

- `git add <archivo>`: Agrega un archivo específico al área de preparación (staging area) para su posterior confirmación (commit). Normalmente se usa `git add .` para agregar todos los archivos modificados, pero también cuando estes interactuando con la consola, es probable, casi siempre, la consola/terminal te indicará que archivos han sido modificados y cuales no, por lo que es recomendable agregar solo los archivos que se han modificado y no todos los archivos del proyecto, ya que esto puede generar conflictos o problemas al momento de hacer un commit. Otro uso de este comando es para agregar todos los archivos modificados y no rastreados (untracked files) al área de preparación, lo que permite incluir todos los cambios realizados en el proyecto en un solo commit. Para hacer esto, puedes usar `git add -A`, que agregará todos los archivos modificados y no rastreados al área de preparación.

- `git commit -m "mensaje"`: Crea un commit con los cambios agregados al área de preparación, junto con un mensaje descriptivo que explique los cambios realizados. Los mensajes de commit deben ser claros y concisos, describiendo brevemente los cambios realizados en el código. Se debe a que facilita la comprensión del historial del proyecto y ayuda a otros desarrolladores a entender las modificaciones realizadas mejor de lo que un mensaje genérico como "cambios realizados" o "actualización de código", en mi caso personal (Ignacio), normalmente los hago en inglés, ya que es costumbre propia, pero dentro del equipo de trabajo usaré el español, ya que es el idioma principal en general y nos comunicamos mejor.

- `git push`: Envía los commits locales al repositorio remoto en GitHub. Este comando actualiza el repositorio en línea con los cambios realizados en tu máquina local.

- `git pull`: Obtiene los cambios más recientes del repositorio remoto y los fusiona con tu copia local. Este comando es útil para mantener tu proyecto actualizado con los cambios realizados por otros colaboradores. Este es importantes si se trabajan con varias ramas (branches) y se quiere mantener la rama principal (main o master) actualizada con los cambios realizados en otras ramas, para evitar conflictos y problemas al momento de hacer un merge, especialmente considerando que si no se hace bien puede crear archivos duplicados, corruptos o incluso perder información importante. Como vimos en la clase del día 19 de Agosto, un grupo de trabajo modifico el mismo archivo y al momento de hacer probablemente un merge, se generaron conflictos que no fueron resueltos correctamente y se corrompieron los archivos de vital importancia.

- `git status`: Muestra el estado actual del repositorio, incluyendo los archivos modificados, los archivos en el área de preparación y los archivos no rastreados. Este comando es útil para verificar qué cambios se han realizado antes de hacer un commit o un push. Como norma personal, utilizar siempre el git status antes de hacer un commit o un push, para evitar errores y problemas al momento de subir los cambios al repositorio remoto.

- `git log`: Muestra el historial de commits del repositorio, incluyendo los mensajes de commit, los autores y las fechas. Este comando es útil para revisar los cambios realizados en el proyecto a lo largo del tiempo y para identificar posibles problemas o errores. Este comando podemos adaptarlo con otra versión que esta 'git log --oneline', que nos muestra el historial de commits de manera más resumida y fácil de leer, mostrando solo el hash del commit y el mensaje de commit, lo que nos puede ayudar a identifcar cambios.

- `git branch`: Muestra las ramas existentes en el repositorio y permite crear nuevas ramas. Las ramas son útiles para trabajar en nuevas características o correcciones de errores sin afectar la rama principal del proyecto. Para usarlo mejor pueden usar un 'git branch <nombre_rama>' para crear una nueva rama y 'git checkout <nombre_rama>' para cambiar a esa rama. También se puede usar 'git checkout -b <nombre_rama>' para crear y cambiar a una nueva rama en un solo comando. Para ver todos los branch (ramas) existentes y en cual estas actualmente, puedes usar 'git branch -a', que te mostrará todas las ramas locales y remotas, y la rama actual estará marcada con un asterisco (*). Es importante tener en cuenta que al trabajar con ramas, es recomendable hacer un pull antes de hacer un push, para evitar conflictos y problemas al momento de fusionar los cambios. Igualmente, la terminal te indicará si hay conflictos al momento de hacer un merge, y te pedirá que los resuelvas antes de poder hacer un push, porque se bloqueará el push hasta que se resuelvan los conflictos.

- `git merge <nombre_rama>`: Fusiona los cambios de una rama específica en la rama actual. Este comando es útil para integrar nuevas características o correcciones de errores en la rama principal del proyecto. Al hacer un merge, es importante revisar los cambios y resolver cualquier conflicto que pueda surgir, para asegurar que el código final sea funcional y coherente, evitando problemas de compatibilidad o errores en el proyecto. Otra agregación a este comando es que se puede usar 'git merge --no-ff <nombre_rama>' para hacer un merge sin fast-forward (es decir estando en la rama actual), lo que crea un commit de merge y mantiene el historial de cambios más claro y fácil de seguir. Esto es útil cuando se quiere mantener un registro de los cambios realizados en una rama específica, especialmente en proyectos grandes con múltiples colaboradores.

- `git remote`: Muestra los repositorios remotos configurados en el proyecto y permite agregar o eliminar repositorios remotos. Este comando es útil para gestionar la conexión entre tu proyecto local y los repositorios remotos en GitHub. Para agregar un repositorio remoto, puedes usar 'git remote add <nombre_remoto> <url_remoto>', y para eliminar un repositorio remoto, puedes usar 'git remote remove <nombre_remoto>'. Es importante tener en cuenta que al trabajar con repositorios remotos, es recomendable hacer un pull antes de hacer un push, para evitar conflictos y problemas al momento de fusionar los cambios. Para listas los repositorios remotos configurados en el proyecto, puedes usar 'git remote -v', que te mostrará los nombres y las URLs de los repositorios remotos.

- `git fetch`: Descarga los cambios más recientes del repositorio remoto sin fusionarlos con tu copia local. Este comando es útil para revisar los cambios realizados por otros colaboradores antes de integrarlos en tu proyecto. Para integrar los cambios descargados, puedes usar 'git merge' o 'git rebase', dependiendo de tus necesidades y preferencias. Es importante tener en cuenta que al trabajar con repositorios remotos, es recomendable hacer un fetch antes de hacer un pull, para evitar conflictos y problemas al momento de fusionar los cambios.

- `git reset`: Deshace cambios en el área de preparación o en el historial de commits. Este comando es útil para revertir cambios no deseados o para reorganizar el historial de commits. Para deshacer cambios en el área de preparación, puedes usar 'git reset <archivo>', y para deshacer commits, puedes usar 'git reset --soft <hash_commit>' o 'git reset --hard <hash_commit>', dependiendo de tus necesidades y preferencias. Considera en tener en cuenta que al usar 'git reset --hard', se perderán los cambios no guardados, por lo que se recomienda usarlo con precaución.

- `git --version`: Muestra la versión de Git instalada en tu sistema. Será solamente útil para verificar si tienes Git instalado y para asegurarte de que estás utilizando una versión compatible con tu proyecto.

- `git config`: Configura opciones de Git, como el nombre de usuario y el correo electrónico, bueno este comando es útil para personalizar el entorno de Git y asegurarte de que tus commits estén correctamente identificados. Para configurar tu nombre de usuario, puedes usar 'git config --global user.name "Tu Nombre"', y para configurar tu correo electrónico, puedes usar 'git config --global user.email'. Bueno, de hecho este comando es útil para iniciar desde un dispositivo remoto que no es tu pc, ya que puedes configurar tu nombre de usuario y correo electrónico para que tus commits estén correctamente identificados, incluso si estás trabajando desde un dispositivo diferente al tuyo.

- `git diff`: Muestra las diferencias entre los archivos modificados y la última versión confirmada (es decir su commit), lo que nos permite revisar los cambios realizados antes de hacer un commit o un push, para asegurarnos de que los cambios sean correctos y no introduzcan errores en el proyecto. Para ver las diferencias entre los archivos modificados y la última versión, puedes usar 'git diff <archivo>', y para ver las diferencias entre dos commits específicos, puedes usar 'git diff <hash_commit1> <hash_commit2>'.

- `git checkout <nombre_rama>`: Cambia a una rama específica en el repositorio. Es un comando bastante útil para trabajar en diferentes ramas del proyecto y mantener un flujo de trabajo organizado. Para cambiar a una rama existente, puedes usar 'git checkout <nombre_rama>', y para crear y cambiar a una nueva rama, puedes usar 'git checkout -b <nombre_rama>'. Ten en cuenta que al cambiar de rama, los cambios no confirmados en la rama actual/main se perderán, por lo que se recomienda hacer un commit o un stash antes de cambiar de rama.

- `git restore`: Restaura archivos específicos a su estado en un commit anterior, lo que permite deshacer cambios no deseados en el proyecto. Es un comando útil para revertir cambios en archivos individuales sin afectar el resto del proyecto. Para restaurar un archivo a su estado en el último commit, puedes usar 'git restore <archivo>', y para restaurar un archivo a su estado en un commit específico, puedes usar 'git restore --source <hash_commit> <archivo>'. Considera que al usar 'git restore', los cambios no confirmados en el archivo se perderán, por lo que se recomienda hacer un commit o un stash antes de restaurar un archivo. También para quitar un arhivo del staging (un staging es un área de preparación donde se guardan los cambios antes de hacer un commit), pero normalmente deja los cambios en el working directory (el working directory es el directorio de trabajo donde se encuentran los archivos del proyecto), puedes usar 'git restore --staged <archivo>', lo que quitará el archivo del área de preparación sin perder los cambios realizados en el archivo.

- `git stash`: Guarda temporalmente los cambios no confirmados en un área de almacenamiento (stash) para poder trabajar en otra rama o realizar otras tareas sin perder los cambios actuales. Este comando vedría siendo útil para cambiar de contexto sin comprometer los cambios realizados. Para guardar los cambios en el stash, puedes usar 'git stash save "mensaje"', y para aplicar los cambios guardados, puedes usar 'git stash apply' o 'git stash pop', dependiendo de tus necesidades y momentos del contexto a aplicar. Considera que es importante tener en cuenta que al usar 'git stash', los cambios guardados se eliminarán del área de preparación y del directorio de trabajo, por lo que se recomienda aplicarlos o recuperarlos antes de hacer un commit o un push.

- `git tag`: Crea etiquetas (tags) en commits específicos para marcar versiones importantes del proyecto. Usar este comando es útil para identificar versiones estables o hitos importantes en el desarrollo del proyecto. Para crear una etiqueta, puedes usar 'git tag <nombre_etiqueta> <hash_commit>', y para listar las etiquetas existentes, puedes usar 'git tag'. Ten en cuenta que al trabajar con etiquetas, es recomendable hacer un push de las etiquetas al repositorio remoto, para que otros colaboradores puedan acceder a ellas. Para hacer un push de las etiquetas, puedes usar 'git push origin <nombre_etiqueta>' o 'git push --tags' para enviar todas las etiquetas al repositorio remoto.

    No creo que trabajemos con etiquetas en este laboratorio, pero en la industria se usan mucho para marcar versiones estables. No tiene mucho sentido usar etiquetas en un proyecto de laboratorio, pero es importante conocerlas y saber cómo usarlas, ya que en proyectos reales son muy útiles para identificar versiones estables y facilitar la gestión del proyecto, ahora, llegado el caso podríamos usar etiquetas para marcar esas versiones estabilizadas sin tener que jugar con fuego con los commits y los merges, ya que si se hace un merge mal hecho, se podría perder información importantes o generar archivos corruptos.

- `git rebase`: Reaplica commits de una rama sobre otra, lo que permite reorganizar el historial de commits y mantener un historial más limpio y lineal. Este es un comando bastante útil para integrar cambios de una rama en otra sin crear un commit de merge, lo que facilita la revisión del historial del proyecto. Para hacer un rebase, puedes usar 'git rebase <nombre_rama>', y para abortar un rebase en curso, puedes usar 'git rebase --abort'. Ten en cuenta que al usar 'git rebase', se pueden generar conflictos que deben resolverse antes de continuar con el proceso de rebase.

    Igual en la práctica imaginemos que esta el branch de la tarea4-ddl y se quiere hacer un rebase (es decir, aplicar los cambios de la rama de la tarea4-ddl sobre la rama principal, es decir, nuestro main), por lo tanto, primero se debe hacer un pull de la rama principal para tener los cambios más recientes, luego se hace un checkout a la rama de la tarea4-ddl y se hace un rebase sobre la rama main, lo que aplicará los cambios de la rama de la tarea4-ddl sobre la rama principal. Si se genera un conflicto, se debe resolver el conflicto y luego continuar con el rebase usando 'git rebase --continue'. Una vez completado el rebase, se puede hacer un push de la rama de la tarea4-ddl al repositorio remoto para actualizar los cambios.

    En resumen, podemos usar rebase para mantener un historial de commits más limpio y lineal, utilizando ramas. Sin embargo, es importante tener en cuenta que al usar 'git rebase', se pueden generar conflictos que deben resolverse antes de continuar con el proceso de rebase, por lo que se recomienda usarlo con precaución y solo cuando sea necesario.

- `git cherry-pick <hash_commit>`: Aplica un commit específico de otra rama a la rama actual. Este comando es útil para seleccionar cambios específicos sin fusionar toda la rama. Para usarlo, primero debes identificar el hash del commit que deseas aplicar y luego ejecutar el comando en la rama donde deseas aplicar ese commit. Ten en cuenta que al usar 'git cherry-pick', se pueden generar conflictos que deben resolverse antes de continuar con el proceso de cherry-pick. Así que podemos usar esta combinación de comandos git log y git cherry-pick para aplicar cambios específicos de una rama a otra sin tener que fusionar toda la rama, es buena para testear cambios específicos o para aplicar correcciones de errores sin afectar el resto del proyecto.

- `git bisect`: Realiza una búsqueda binaria para identificar el commit que introdujo un error o problema en el proyecto. El comando bisect es útil para depurar problemas y encontrar la causa raíz de los errores.

    Para usarlo, primero debes iniciar el proceso de bisect con 'git bisect start', luego marcar un commit bueno con 'git bisect good <hash_commit>' y un commit malo con 'git bisect bad <hash_commit>'. Git seleccionará automáticamente un commit intermedio para probar, y deberás marcarlo como bueno o malo hasta que se identifique el commit problemático. Ten en cuenta que al usar 'git bisect', se pueden generar conflictos que deben resolverse antes de continuar con el proceso de bisect.

    Bueno, este generalmente solo se utiliza en proyectos grandes con muchos commits y cambios, pero es bueno conocerlo y saber cómo usarlo, ya que puede ser útil para depurar problemas y encontrar la causa raíz de los errores en el proyecto. Es como usar un debugger para encontrar el commit que introdujo un error o problema en el proyecto. Por cierto, un debugger es una herramienta que permite ejecutar un programa paso a paso, inspeccionar variables y controlar el flujo de ejecución para identificar errores o problemas en el código. GitHub tiene Actions, que es una herramienta de integración continua y despliegue que permite automatizar pruebas, compilaciones y despliegues de manera eficiente. Esta cosa se puede utilizar para ejecutar pruebas automatizadas, compilar el código y desplegar aplicaciones en diferentes entornos, lo que facilita la gestión del ciclo de vida del desarrollo de software. Es muy útil para proyectos que se requiere testeo recurrente y despliegue continuo, ya que permite detectar errores y problemas de manera temprana y mejorar la calidad del software.

- `git blame <archivo>`: Muestra información sobre quién realizó cambios en cada línea de un archivo específico, lo que permite rastrear la autoría de los cambios y entender el historial del proyecto. Este comando es útil para identificar a los responsables de los cambios y para comprender el contexto de las modificaciones realizadas en el código. Para usarlo, simplemente ejecuta 'git blame <archivo>' y Git mostrará una lista de líneas con información sobre el autor, la fecha y el hash del commit correspondiente a cada línea. Considera que al usar 'git blame', se pueden generar conflictos si se intenta modificar un archivo mientras se está viendo su historial, por lo que se recomienda usarlo con precaución y solo cuando sea necesario.

- `git revert <hash_commit>`: Crea un nuevo commit que deshace los cambios introducidos por un commit específico, lo que permite revertir cambios no deseados sin modificar el historial de commits. Es un comando útil para deshacer cambios problemáticos o errores introducidos en el proyecto. Para darle un uso, primero debes identificar el hash del commit que deseas revertir y luego ejecutar el comando en la rama donde deseas aplicar el revert. Ten en cuenta que al usar 'git revert', se creará un nuevo commit que deshace los cambios del commit especificado.

## ¿Qué más se puede hacer con Git en general ahora que sabemos comandos?

Lo que se puede hacer con Git es prácticamente infinito, ya que es una herramienta muy poderosa y flexible que permite gestionar proyectos de desarrollo de software de manera eficiente. Algunas cosas adicionales que se pueden hacer con Git incluyen:

- Crear y gestionar ramas de manera avanzada, utilizando comandos como `git branch`, `git checkout`, `git merge` y `git rebase` para organizar el flujo de trabajo y mantener un historial de commits limpio y lineal.

- Colaborar con otros desarrolladores mediante pull requests, issues y wikis en GitHub, lo que facilita la revisión de código, la discusión de cambios y la documentación del proyecto.

- Automatizar tareas de integración continua y despliegue utilizando herramientas como GitHub Actions, lo que permite ejecutar pruebas automatizadas, compilar el código y desplegar aplicaciones en diferentes entornos de manera eficiente.

- Personalizar la configuración de Git y GitHub para adaptarse a las necesidades del proyecto y del equipo de desarrollo, utilizando comandos como `git config` y configuraciones de repositorio en GitHub.

- Explorar y analizar el historial de commits utilizando comandos como `git log`, `git diff` y `git blame`, lo que permite comprender el contexto de los cambios realizados en el proyecto y rastrear la autoría de los cambios.

- Integrar Git con otras herramientas y servicios, como sistemas de seguimiento de errores, plataformas de colaboración y entornos de desarrollo integrados (IDEs), lo que permite mejorar la productividad y la eficiencia del equipo de desarrollo.

- Aprender y dominar Git y GitHub es un proceso continuo, ya que estas herramientas están en constante evolución y ofrecen nuevas funcionalidades y mejoras con el tiempo. Por lo tanto, es importante mantenerse actualizado con las últimas novedades y mejores prácticas en el uso de Git y GitHub para aprovechar al máximo sus capacidades y mejorar la gestión de proyectos de desarrollo de software.

## Funcionalidades de GitHub

GitHub es como un GooglePlay para desarrolladores, ya que permite a los desarrolladores almacenar, compartir y colaborar en proyectos de desarrollo de software, programación, codificación, mejora de habilidades, aprendizaje de nuevas metodologías de trabajo, etc.

Personalmente recomiendo los AWESOME REPOSITORIES, que son repositorios de código abierto que contienen proyectos interesantes y útiles para aprender y mejorar habilidades de programación. Algunos ejemplos de repositorios interesantes en GitHub incluyen:

- [Awesome Python]
- [Awesome JavaScript]
- [Awesome Machine Learning]
- [Awesome Data Science]
- [Awesome Web Development]
- [Awesome Open Source]
- [Awesome Algorithms]
- [Awesome DevOps]
- [Awesome Security]
- [Awesome Game Development]
- [Awesome Mobile Development]
- [Awesome Cybersecurity]

Eso es solo una pequeña muestra de los muchos repositorios interesantes que se pueden encontrar en GitHub. Explorar estos repositorios puede ser una excelente manera de aprender nuevas tecnologías, mejorar habilidades de programación y colaborar con otros desarrolladores en proyectos de código abierto. Si bien la mayoría de esos repositorios están en inglés o en un lenguaje muy técnico en inglés, el aprendizaje continuo y la práctica son clave para mejorar habilidades de programación y mantener actualizado con las últimas tendencias y tecnologías.
